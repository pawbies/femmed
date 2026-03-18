class PkCalculator
  PALETTE = %w[#4f8ef7 #f5a623 #34c98a #e05c6e #a78bfa].freeze

  # Returns an array of { name:, concentration:, rate: } for each active
  # ingredient the user currently has in their system.
  # rate is the instantaneous change in mg/L per hour (positive = rising, negative = falling).
  def self.current_concentrations(prescriptions, now: Time.current)
    now_ts = now.to_i
    dt = 0.01 # ~36 seconds, small enough for accurate derivative

    ingredient_map = {}

    prescriptions.each do |prescription|
      next unless prescription.active?

      release = pk_release_profile(prescription.medication)
      doses = prescription.recent_doses.map { |d| { taken_at: d.taken_at.to_i, amount: d.amount_taken } }
      next if doses.empty?

      pk_ingredients(prescription.medication_version).each do |ing|
        entry = ingredient_map[ing[:name]] ||= { id: ing[:id], name: ing[:name], concentration: 0.0, rate: 0.0 }

        c_now = concentration_from_doses(ing, release, doses, now_ts, 0)
        c_dt  = concentration_from_doses(ing, release, doses, now_ts, dt)

        entry[:concentration] += c_now
        entry[:rate] += (c_dt - c_now) / dt
      end
    end

    ingredient_map.values.reject { |i| i[:concentration] == 0.0 && i[:rate] == 0.0 }
  end

  # Single hypothetical dose at t=0, plotted over 0–24h.
  # Used on the medication show page.
  def self.for_medication(medication_version)
    medication = medication_version.medication

    ingredients = pk_ingredients(medication_version)
    release     = pk_release_profile(medication)

    build_plot_data(ingredients, 0..24) do |ing, t|
      next 0.0 if t < 0
      concentration_for_single_dose(ing, release, t)
    end
  end

  # Real dose history, plotted from -past to +future hours around now.
  # Used on the prescription card.
  def self.for_prescription(prescription, now: Time.current)
    ingredients = pk_ingredients(prescription.medication_version)
    release     = pk_release_profile(prescription.medication)
    doses       = prescription.recent_doses.map { |d| { taken_at: d.taken_at.to_i, amount: d.amount_taken } }
    now_ts      = now.to_i
    x_start     = (prescription.preview_past * -1).to_i
    x_end       = prescription.preview_future.to_i

    result = build_plot_data(ingredients, x_start..(x_end + 1)) do |ing, t|
      concentration_from_doses(ing, release, doses, now_ts, t)
    end

    # Add "now" dots showing current concentration at t=0
    result[:dots] = ingredients.each_with_index.map do |ing, idx|
      {
        time: 0,
        ingredient: ing[:name],
        concentration: concentration_from_doses(ing, release, doses, now_ts, 0),
        color: PALETTE[idx % PALETTE.length]
      }
    end

    result
  end

  # --- shared math ---

  def self.concentration_for_single_dose(ing, release, t)
    _ke = ke(ing[:half_life])
    ka  = ing[:absorption_rate]
    vd  = ing[:volume_of_distribution]
    return 0.0 if (ka - _ke).abs < 0.0001

    case release[:name]
    when "Bimodal"
      pulse(ing[:amount], vd, ka, _ke, t) +
        pulse(ing[:amount], vd, ka, _ke, t, release[:delay])
    when "Extended"
      extended(ing[:amount], vd, _ke, t, release[:release_duration])
    else
      pulse(ing[:amount], vd, ka, _ke, t)
    end
  end

  def self.concentration_from_doses(ing, release, doses, now_ts, t)
    doses.sum do |dose|
      elapsed = (now_ts + t * 3600 - dose[:taken_at]) / 3600.0
      next 0.0 if elapsed < 0

      amount = ing[:amount] * dose[:amount]
      _ke    = ke(ing[:half_life])
      ka     = ing[:absorption_rate]
      vd     = ing[:volume_of_distribution]
      next 0.0 if (ka - _ke).abs < 0.0001

      case release[:name]
      when "Bimodal"
        pulse(amount, vd, ka, _ke, elapsed) +
          pulse(amount, vd, ka, _ke, elapsed, release[:delay])
      when "Extended"
        extended(dose[:amount], vd, _ke, elapsed, release[:release_duration])
      else
        pulse(amount, vd, ka, _ke, elapsed)
      end
    end
  end

  def self.ke(half_life)
    Math.log(2) / half_life
  end

  def self.pulse(amount, vd, ka, ke, elapsed, offset = 0)
    e = elapsed - offset
    return 0.0 if e < 0
    [ 0.0, (amount / vd) * (ka / (ka - ke)) * (Math.exp(-ke * e) - Math.exp(-ka * e)) ].max
  end

  def self.extended(amount, vd, ke, elapsed, release_duration)
    base = (amount / release_duration) / (vd * ke)
    c = if elapsed <= release_duration
      base * (1 - Math.exp(-ke * elapsed))
    else
      base * (1 - Math.exp(-ke * release_duration)) * Math.exp(-ke * (elapsed - release_duration))
    end
    [ 0.0, c ].max
  end

  # --- data assembly ---

  def self.build_plot_data(ingredients, x_range)
    series       = []
    local_maxima = []

    ingredients.each_with_index do |ing, idx|
      color  = PALETTE[idx % PALETTE.length]
      points = x_range.map do |t|
        { time: t, ingredient: ing[:name], concentration: yield(ing, t), color: color }
      end

      series.concat(points)

      points.each_with_index do |pt, i|
        next if i == 0 || i >= points.length - 1
        if pt[:concentration] > points[i - 1][:concentration] &&
           pt[:concentration] > points[i + 1][:concentration]
          local_maxima << pt
        end
      end
    end

    y_max = series.map { |d| d[:concentration] }.max || 1.0

    {
      series: series,
      local_maxima: local_maxima,
      y_max: y_max,
      ingredients: ingredients.each_with_index.map { |ing, idx|
        { name: ing[:name], color: PALETTE[idx % PALETTE.length] }
      }
    }
  end

  def self.pk_ingredients(medication_version)
    medication_version.pk_compatible_ingredients.map do |mvi|
      ai = mvi.active_ingredient
      {
        id:                     ai.id,
        name:                   ai.name,
        amount:                 mvi.amount * mvi.pk_multiplier,
        half_life:              ai.half_life,
        absorption_rate:        ai.absorption_rate,
        volume_of_distribution: ai.volume_of_distribution
      }
    end
  end

  def self.pk_release_profile(medication)
    mrp = medication.medication_release_profile
    {
      name: medication.release_profile&.name || "Immediate",
      delay: mrp.delay,
      release_duration: mrp.release_duration
    }.compact
  end

  private_class_method :concentration_for_single_dose, :concentration_from_doses,
    :ke, :pulse, :extended, :build_plot_data, :pk_ingredients, :pk_release_profile
end
