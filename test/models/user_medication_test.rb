require "test_helper"

class PrescriptionTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert prescriptions(:alice_ritalin_ir).valid?
  end

  test "should require a user" do
    um = Prescription.new(medication_version: medication_versions(:ritalin_ir_10mg), dosage: 10)
    assert_not um.valid?
    assert_includes um.errors[:user], "must exist"
  end

  test "should require a medication_version" do
    um = Prescription.new(user: users(:alice), dosage: 10)
    assert_not um.valid?
    assert_includes um.errors[:medication_version], "must exist"
  end

  test "should require dosage" do
    um = Prescription.new(user: users(:alice), medication_version: medication_versions(:ritalin_ir_10mg))
    assert_not um.valid?
    assert_includes um.errors[:dosage], "can't be blank"
  end

  test "should require dosage to be an integer" do
    um = Prescription.new(user: users(:alice), medication_version: medication_versions(:ritalin_ir_10mg), dosage: 1.5)
    assert_not um.valid?
    assert_includes um.errors[:dosage], "must be an integer"
  end

  test "should belong to a user" do
    assert_equal users(:alice), prescriptions(:alice_ritalin_ir).user
  end

  test "should belong to a medication_version" do
    assert_equal medication_versions(:ritalin_ir_10mg), prescriptions(:alice_ritalin_ir).medication_version
  end

  test "should destroy packs when destroyed" do
    um = prescriptions(:alice_ritalin_ir)
    pack_count = um.packs.count
    assert pack_count > 0
    assert_difference("Pack.count", -pack_count) do
      um.destroy
    end
  end
end
