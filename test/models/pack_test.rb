require "test_helper"

class PackTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert packs(:alice_ritalin_ir_pack).valid?
  end

  test "should require a prescription" do
    pack = Pack.new(amount: 30, aquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:prescription], "must exist"
  end

  test "should require amount" do
    pack = Pack.new(prescription: prescriptions(:alice_ritalin_ir), aquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "can't be blank"
  end

  test "should require amount to be an integer" do
    pack = Pack.new(prescription: prescriptions(:alice_ritalin_ir), amount: 1.5, aquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "must be an integer"
  end

  test "should require amount to not be zero" do
    pack = Pack.new(prescription: prescriptions(:alice_ritalin_ir), amount: 0, aquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "must be greater than 0"
  end

  test "should require amount to not be negative" do
    pack = Pack.new(prescription: prescriptions(:alice_ritalin_ir), amount: -2, aquired_at: Date.today)
    assert_not pack.valid?
    assert_includes pack.errors[:amount], "must be greater than 0"
  end

  test "should belong to a prescription" do
    assert_equal prescriptions(:alice_ritalin_ir), packs(:alice_ritalin_ir_pack).prescription
  end

  test "should have many doses" do
    assert_respond_to packs(:alice_ritalin_ir_pack), :doses
  end

  test "should destroy doses when destroyed" do
    pack = packs(:alice_ritalin_ir_pack)
    dose_count = pack.doses.count
    assert dose_count > 0
    assert_difference("Dose.count", -dose_count) do
      pack.destroy
    end
  end
end
