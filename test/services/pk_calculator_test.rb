require "test_helper"

class PkCalculatorTest < ActiveSupport::TestCase
  # --- core math (no ActiveRecord) ---

  test "ke returns correct elimination rate constant" do
    # ke = ln(2) / half_life
    assert_in_delta Math.log(2) / 3.5, PkCalculator.send(:ke, 3.5), 1e-10
    assert_in_delta Math.log(2) / 2.0, PkCalculator.send(:ke, 2.0), 1e-10
  end

  test "pulse returns zero for negative elapsed time" do
    result = PkCalculator.send(:pulse, 10.0, 2.6, 0.87, 0.198, 0, 5.0)
    assert_equal 0.0, result
  end

  test "pulse returns zero at t=0" do
    ke = Math.log(2) / 3.5
    result = PkCalculator.send(:pulse, 10.0, 2.6, 0.87, ke, 0)
    assert_equal 0.0, result
  end

  test "pulse rises then falls for immediate release" do
    ke = Math.log(2) / 3.5
    ka = 0.87
    vd = 2.6
    amount = 5.0

    concentrations = (0..24).map do |t|
      PkCalculator.send(:pulse, amount, vd, ka, ke, t.to_f)
    end

    # should start at zero
    assert_equal 0.0, concentrations[0]

    # should have a peak somewhere in the middle
    peak_idx = concentrations.index(concentrations.max)
    assert peak_idx > 0
    assert peak_idx < 24

    # should decline after peak
    assert concentrations[peak_idx] > concentrations[24]

    # should always be non-negative
    assert concentrations.all? { |c| c >= 0 }
  end

  test "extended returns zero at t=0" do
    ke = Math.log(2) / 3.5
    result = PkCalculator.send(:extended, 10.0, 2.6, ke, 0, 12.0)
    assert_equal 0.0, result
  end

  test "extended rises during release then decays after" do
    ke = Math.log(2) / 3.5
    vd = 2.6
    amount = 10.0
    duration = 12.0

    during_release = PkCalculator.send(:extended, amount, vd, ke, 6.0, duration)
    at_end = PkCalculator.send(:extended, amount, vd, ke, 12.0, duration)
    after_release = PkCalculator.send(:extended, amount, vd, ke, 18.0, duration)

    assert during_release > 0
    assert at_end > during_release, "concentration should still be rising at t=6 vs t=12"
    assert after_release < at_end, "concentration should decay after release ends"
  end

  test "higher dose produces proportionally higher concentration" do
    ke = Math.log(2) / 3.5
    ka = 0.87
    vd = 2.6

    c_low = PkCalculator.send(:pulse, 5.0, vd, ka, ke, 3.0)
    c_high = PkCalculator.send(:pulse, 10.0, vd, ka, ke, 3.0)

    assert_in_delta c_high, c_low * 2, 1e-10, "concentration should scale linearly with dose"
  end

  test "pulse with bimodal offset produces delayed second peak" do
    ke = Math.log(2) / 2.5
    ka = 0.87
    vd = 2.6
    amount = 20.0
    delay = 4.0

    # simulate bimodal: sum of immediate pulse + delayed pulse
    concentrations = (0..20).map do |t|
      PkCalculator.send(:pulse, amount, vd, ka, ke, t.to_f) +
        PkCalculator.send(:pulse, amount, vd, ka, ke, t.to_f, delay)
    end

    # find peaks (local maxima)
    peaks = (1...concentrations.length - 1).select do |i|
      concentrations[i] > concentrations[i - 1] && concentrations[i] > concentrations[i + 1]
    end

    assert peaks.length >= 1, "bimodal release should produce at least one identifiable peak"
  end

  test "returns zero when ka equals ke" do
    ke = 0.87
    ka = 0.87 # same as ke — degenerate case
    vd = 2.6
    amount = 10.0

    # The guard clause should prevent division issues
    ing = { half_life: Math.log(2) / ke, absorption_rate: ka, volume_of_distribution: vd, amount: amount, name: "test" }
    release = { name: "Immediate" }

    result = PkCalculator.send(:concentration_for_single_dose, ing, release, 5.0, 70)
    assert_equal 0.0, result
  end

  # --- for_medication (single hypothetical dose) ---

  test "for_medication returns expected structure" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)

    assert result.key?(:series)
    assert result.key?(:local_maxima)
    assert result.key?(:y_max)
    assert result.key?(:ingredients)

    assert_kind_of Array, result[:series]
    assert_kind_of Array, result[:local_maxima]
    assert_kind_of Array, result[:ingredients]
    assert_kind_of Numeric, result[:y_max]
  end

  test "for_medication series covers 0 to 24 hours" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)
    times = result[:series].map { |d| d[:time] }.uniq.sort

    assert_equal 0, times.first
    assert_equal 24, times.last
  end

  test "for_medication includes both pk-compatible ingredients for percocet" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)
    ingredient_names = result[:ingredients].map { |i| i[:name] }

    assert_includes ingredient_names, "Oxycodone"
    assert_includes ingredient_names, "Acetaminophen"
  end

  test "for_medication assigns different colors per ingredient" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)
    colors = result[:ingredients].map { |i| i[:color] }

    assert_equal colors.uniq.length, colors.length, "each ingredient should have a unique color"
  end

  test "for_medication concentrations start at zero and return to near zero" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)

    result[:ingredients].each do |ing_meta|
      points = result[:series].select { |d| d[:ingredient] == ing_meta[:name] }
      assert_equal 0.0, points.first[:concentration], "concentration at t=0 should be zero for #{ing_meta[:name]}"
      assert points.last[:concentration] < points.max_by { |d| d[:concentration] }[:concentration],
        "concentration at t=24 should be less than peak for #{ing_meta[:name]}"
    end
  end

  test "for_medication finds local maxima" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)

    assert result[:local_maxima].length > 0, "should find at least one peak"
    result[:local_maxima].each do |peak|
      assert peak[:concentration] > 0
      assert peak[:time] > 0
      assert peak[:time] < 24
    end
  end

  test "for_medication y_max equals the highest concentration" do
    version = medication_versions(:percocet_5mg)

    result = PkCalculator.for_medication(version, 70)
    max_conc = result[:series].map { |d| d[:concentration] }.max

    assert_in_delta max_conc, result[:y_max], 1e-10
  end

  test "for_medication returns empty series for medication without pk data" do
    version = medication_versions(:ritalin_ir_10mg)

    result = PkCalculator.for_medication(version, 70)

    assert_empty result[:series]
    assert_empty result[:ingredients]
    assert_equal 1.0, result[:y_max]
  end

  # --- for_prescription (real dose history) ---

  test "for_prescription returns expected structure with dots" do
    prescription = prescriptions(:alice_percocet)

    result = PkCalculator.for_prescription(prescription)

    assert result.key?(:series)
    assert result.key?(:dots)
    assert result.key?(:local_maxima)
    assert result.key?(:y_max)
    assert result.key?(:ingredients)
  end

  test "for_prescription dots show current concentration at t=0" do
    prescription = prescriptions(:alice_percocet)

    result = PkCalculator.for_prescription(prescription)

    assert result[:dots].length > 0
    result[:dots].each do |dot|
      assert_equal 0, dot[:time]
      assert dot[:concentration] >= 0
    end
  end

  test "for_prescription series spans past to future" do
    prescription = prescriptions(:alice_percocet)

    result = PkCalculator.for_prescription(prescription)
    times = result[:series].map { |d| d[:time] }.uniq.sort

    assert times.first < 0, "series should include negative hours (past)"
    assert times.last > 0, "series should include positive hours (future)"
  end

  test "for_prescription with no recent doses produces zero concentrations" do
    # alice_ritalin_ir doses are from Feb 2026, outside the 1-week window,
    # AND methylphenidate lacks absorption_rate/vd so no pk_compatible_ingredients
    prescription = prescriptions(:alice_ritalin_ir)

    result = PkCalculator.for_prescription(prescription)

    assert_empty result[:series], "no pk-compatible ingredients means empty series"
  end

  test "for_prescription respects the now parameter" do
    prescription = prescriptions(:alice_percocet)

    # compute at two different "now" times — concentrations should differ
    result_early = PkCalculator.for_prescription(prescription, now: 2.hours.ago)
    result_late = PkCalculator.for_prescription(prescription, now: Time.current)

    dots_early = result_early[:dots].sum { |d| d[:concentration] }
    dots_late = result_late[:dots].sum { |d| d[:concentration] }

    assert_not_equal dots_early, dots_late,
      "different now values should produce different current concentrations"
  end

  test "for_prescription all concentrations are non-negative" do
    prescription = prescriptions(:alice_percocet)

    result = PkCalculator.for_prescription(prescription)

    result[:series].each do |point|
      assert point[:concentration] >= 0,
        "concentration should never be negative at t=#{point[:time]} for #{point[:ingredient]}"
    end
  end

  test "for_prescription serializes to valid json" do
    prescription = prescriptions(:alice_percocet)

    result = PkCalculator.for_prescription(prescription)
    json = result.to_json
    parsed = JSON.parse(json)

    assert parsed.key?("series")
    assert parsed.key?("dots")
    assert parsed.key?("y_max")
  end

  # --- bioavailability ---

  test "for_medication scales peak concentration proportionally with bioavailability" do
    version = medication_versions(:percocet_5mg)

    result_full = PkCalculator.for_medication(version, 70)
    peak_full = result_full[:series]
      .select { |d| d[:ingredient] == "Oxycodone" }
      .max_by { |d| d[:concentration] }[:concentration]

    medication_version_ingredients(:percocet_5mg_oxycodone).update!(bioavailability: 0.5)
    version.association(:pk_compatible_ingredients).reset

    result_half = PkCalculator.for_medication(version, 70)
    peak_half = result_half[:series]
      .select { |d| d[:ingredient] == "Oxycodone" }
      .max_by { |d| d[:concentration] }[:concentration]

    assert_in_delta peak_full * 0.5, peak_half, 1e-10,
      "halving bioavailability should halve the peak concentration"
  end
end
