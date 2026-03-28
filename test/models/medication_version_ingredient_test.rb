require "test_helper"

class MedicationVersionIngredientTest < ActiveSupport::TestCase
  # --- bioavailability validation ---

  test "bioavailability is valid at 1.0" do
    mvi = medication_version_ingredients(:percocet_5mg_oxycodone).dup
    mvi.bioavailability = 1.0
    assert mvi.valid?
  end

  test "bioavailability is valid between 0 and 1" do
    mvi = medication_version_ingredients(:percocet_5mg_oxycodone).dup
    mvi.bioavailability = 0.5
    assert mvi.valid?
  end

  test "bioavailability is invalid when nil" do
    mvi = medication_version_ingredients(:percocet_5mg_oxycodone).dup
    mvi.bioavailability = nil
    assert_not mvi.valid?
    assert_includes mvi.errors[:bioavailability], "can't be blank"
  end

  test "bioavailability is invalid at 0" do
    mvi = medication_version_ingredients(:percocet_5mg_oxycodone).dup
    mvi.bioavailability = 0
    assert_not mvi.valid?
  end

  test "bioavailability is invalid when negative" do
    mvi = medication_version_ingredients(:percocet_5mg_oxycodone).dup
    mvi.bioavailability = -0.1
    assert_not mvi.valid?
  end

  test "bioavailability is invalid when greater than 1" do
    mvi = medication_version_ingredients(:percocet_5mg_oxycodone).dup
    mvi.bioavailability = 1.1
    assert_not mvi.valid?
  end
end
