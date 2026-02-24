require "test_helper"

class DoseTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert doses(:alice_ritalin_ir_dose_1).valid?
  end

  test "should require a prescription" do
    dose = Dose.new(amount_taken: 1.0, taken_at: Time.current)
    assert_not dose.valid?
    assert_includes dose.errors[:prescription], "must exist"
  end

  test "should require amount_taken" do
    dose = Dose.new(prescription: prescriptions(:alice_ritalin_ir), taken_at: Time.current)
    assert_not dose.valid?
    assert_includes dose.errors[:amount_taken], "can't be blank"
  end

  test "should require amount_taken to be numeric" do
    dose = Dose.new(prescription: prescriptions(:alice_ritalin_ir), amount_taken: "abc", taken_at: Time.current)
    assert_not dose.valid?
    assert_includes dose.errors[:amount_taken], "is not a number"
  end

  test "should require taken_at" do
    dose = Dose.new(prescription: prescriptions(:alice_ritalin_ir), amount_taken: 1.0)
    assert_not dose.valid?
    assert_includes dose.errors[:taken_at], "can't be blank"
  end

  test "should belong to a prescription" do
    assert_equal prescriptions(:alice_ritalin_ir), doses(:alice_ritalin_ir_dose_1).prescription
  end
end
