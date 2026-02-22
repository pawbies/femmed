require "test_helper"

class DoseTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert doses(:alice_ritalin_ir_dose_1).valid?
  end

  test "should require a pack" do
    dose = Dose.new(amount_taken: 1.0, taken_at: Time.current)
    assert_not dose.valid?
    assert_includes dose.errors[:pack], "must exist"
  end

  test "should require amount_taken" do
    dose = Dose.new(pack: packs(:alice_ritalin_ir_pack), taken_at: Time.current)
    assert_not dose.valid?
    assert_includes dose.errors[:amount_taken], "can't be blank"
  end

  test "should require amount_taken to be numeric" do
    dose = Dose.new(pack: packs(:alice_ritalin_ir_pack), amount_taken: "abc", taken_at: Time.current)
    assert_not dose.valid?
    assert_includes dose.errors[:amount_taken], "is not a number"
  end

  test "should require taken_at" do
    dose = Dose.new(pack: packs(:alice_ritalin_ir_pack), amount_taken: 1.0)
    assert_not dose.valid?
    assert_includes dose.errors[:taken_at], "can't be blank"
  end

  test "should belong to a pack" do
    assert_equal packs(:alice_ritalin_ir_pack), doses(:alice_ritalin_ir_dose_1).pack
  end
end
