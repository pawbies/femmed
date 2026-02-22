require "test_helper"

class MedicationTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert medications(:ritalin_ir).valid?
  end

  test "should require a name" do
    medication = Medication.new(form: forms(:tablet))
    assert_not medication.valid?
    assert_includes medication.errors[:name], "can't be blank"
  end

  test "should allow optional labeler" do
    medication = Medication.new(name: "Testamed", form: forms(:tablet), labeler: nil)
    assert medication.valid?
  end

  test "should belong to a form" do
    assert_equal forms(:tablet), medications(:ritalin_ir).form
  end

  test "should belong to a labeler" do
    assert_equal labelers(:infecto_pharm), medications(:ritalin_ir).labeler
  end

  test "should have versions" do
    assert_respond_to medications(:ritalin_ir), :versions
  end
end
