require "test_helper"

class LabWork::ResultTest < ActiveSupport::TestCase
  test "valid with required attributes" do
    result = LabWork::Result.new(
      lab_work: lab_works(:lab_work),
      bio_marker: bio_markers(:glucose),
      value: 5.4
    )
    assert result.valid?
  end

  test "invalid without value" do
    result = LabWork::Result.new(
      lab_work: lab_works(:lab_work),
      bio_marker: bio_markers(:glucose)
    )
    assert_not result.valid?
    assert_includes result.errors[:value], "can't be blank"
  end

  test "invalid with negative value" do
    result = LabWork::Result.new(
      lab_work: lab_works(:lab_work),
      bio_marker: bio_markers(:glucose),
      value: -1.0
    )
    assert_not result.valid?
    assert_includes result.errors[:value], "must be greater than or equal to 0"
  end

  test "valid with zero value" do
    result = LabWork::Result.new(
      lab_work: lab_works(:lab_work),
      bio_marker: bio_markers(:glucose),
      value: 0
    )
    assert result.valid?
  end

  test "invalid without lab_work" do
    result = LabWork::Result.new(
      bio_marker: bio_markers(:glucose),
      value: 5.4
    )
    assert_not result.valid?
    assert_includes result.errors[:lab_work], "must exist"
  end

  test "invalid without bio_marker" do
    result = LabWork::Result.new(
      lab_work: lab_works(:lab_work),
      value: 5.4
    )
    assert_not result.valid?
    assert_includes result.errors[:bio_marker], "must exist"
  end

  test "belongs to lab_work" do
    result = lab_work_results(:lab_work_glucose)
    assert_equal lab_works(:lab_work), result.lab_work
  end

  test "belongs to bio_marker" do
    result = lab_work_results(:lab_work_glucose)
    assert_equal bio_markers(:glucose), result.bio_marker
  end
end
