require "test_helper"

class MedicationTest < ActiveSupport::TestCase
  setup do
    @tablet_form = forms(:tablet)
  end

  test "should require a name" do
    medication = Medication.new(
      form: @tablet_form,
      release_type: "immediate"
    )
    assert_not medication.valid?
    assert_includes medication.errors[:name], "can't be blank"
  end

  test "should fallback to immediate release type" do
    medication = Medication.new(
      name: "New Medication",
      form: @tablet_form
    )
    assert medication.valid?
    assert_equal medication.release_type, "immediate"
  end

  test "should require a form" do
    medication = Medication.new(
      name: "New Medication",
      release_type: "immediate"
    )
    assert_not medication.valid?
    assert_includes medication.errors[:form], "must exist"
  end

  test "should allow optional labeler" do
    medication = Medication.new(
      name: "Testamed",
      form: forms(:tablet),
      labeler: nil,
      release_type: "immediate"
    )
    assert medication.valid?
  end
end
