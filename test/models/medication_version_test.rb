require "test_helper"

class MedicationVersionTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert medication_versions(:ritalin_ir_10mg).valid?
  end

  test "should require added_name" do
    version = MedicationVersion.new(medication: medications(:ritalin_ir), ndc: "0000-0000-00")
    assert_not version.valid?
    assert_includes version.errors[:added_name], "can't be blank"
  end

  test "should require ndc" do
    version = MedicationVersion.new(medication: medications(:ritalin_ir), added_name: "10mg")
    assert_not version.valid?
    assert_includes version.errors[:ndc], "can't be blank"
  end

  test "should belong to a medication" do
    assert_equal medications(:ritalin_ir), medication_versions(:ritalin_ir_10mg).medication
  end

  test "should return full_name" do
    version = medication_versions(:ritalin_ir_10mg)
    assert_equal "#{version.medication.name} #{version.added_name}", version.full_name
  end
end
