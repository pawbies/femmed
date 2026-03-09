require "test_helper"

class MedicationTest < ActiveSupport::TestCase
  setup do
    @immediate_release = release_profiles(:immediate)
    @tablet_form = forms(:tablet)
  end

  test "should require a name" do
    medication = Medication.new(
      form: @tablet_form,
      medication_release_profile_attributes: { release_profile: @immediate_release }
    )
    assert_not medication.valid?
    assert_includes medication.errors[:name], "can't be blank"
  end

  test "should require a release profile" do
    medication = Medication.new(
      name: "New Medication",
      form: @tablet_form
    )
    assert_not medication.valid?
    assert_includes medication.errors[:medication_release_profile], "can't be blank"
  end

  test "should require a form" do
    medication = Medication.new(
      name: "New Medication",
      medication_release_profile_attributes: { release_profile: @immediate_release }
    )
    assert_not medication.valid?
    assert_includes medication.errors[:form], "must exist"
  end

  test "should allow optional labeler" do
    medication = Medication.new(
      name: "Testamed",
      form: forms(:tablet),
      labeler: nil,
      medication_release_profile_attributes: { release_profile: @immediate_release }
    )
    assert medication.valid?
  end
end
