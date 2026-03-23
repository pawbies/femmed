require "test_helper"

class Prescription::PackTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert prescription_packs(:alice_ritalin_ir_pack).valid?
  end

  test "should require a prescription" do
    pack = Prescription::Pack.new(amount: 30, acquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:prescription], "must exist"
  end

  test "should require amount" do
    pack = Prescription::Pack.new(prescription: prescriptions(:alice_ritalin_ir), acquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "can't be blank"
  end

  test "should require amount to be an integer" do
    pack = Prescription::Pack.new(prescription: prescriptions(:alice_ritalin_ir), amount: 1.5, acquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "must be an integer"
  end

  test "should require amount to not be zero" do
    pack = Prescription::Pack.new(prescription: prescriptions(:alice_ritalin_ir), amount: 0, acquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "must be greater than 0"
  end

  test "should require amount to not be negative" do
    pack = Prescription::Pack.new(prescription: prescriptions(:alice_ritalin_ir), amount: -2, acquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "must be greater than 0"
  end

  test "should belong to a prescription" do
    assert_equal prescriptions(:alice_ritalin_ir), prescription_packs(:alice_ritalin_ir_pack).prescription
  end
end
