require "test_helper"

class BioMarkerTest < ActiveSupport::TestCase
  def valid_marker
    BioMarker.new(
      name: "Cholesterol",
      unit: "mg/dL"
    )
  end

  test "valid with required attributes" do
    assert valid_marker.valid?
  end

  test "valid with all attributes" do
    marker = valid_marker
    marker.abbreviation = "CHOL"
    marker.description = "Total cholesterol level"
    assert marker.valid?
  end

  test "invalid without name" do
    marker = valid_marker
    marker.name = nil
    assert_not marker.valid?
    assert_includes marker.errors[:name], "can't be blank"
  end

  test "invalid with blank name" do
    marker = valid_marker
    marker.name = "  "
    assert_not marker.valid?
    assert_includes marker.errors[:name], "can't be blank"
  end

  test "invalid with duplicate name" do
    marker = valid_marker
    marker.name = bio_markers(:glucose).name
    assert_not marker.valid?
    assert_includes marker.errors[:name], "has already been taken"
  end

  test "invalid with name longer than 30 characters" do
    marker = valid_marker
    marker.name = "A" * 31
    assert_not marker.valid?
    assert marker.errors[:name].any?
  end

  test "valid with name at max length" do
    marker = valid_marker
    marker.name = "A" * 30
    assert marker.valid?
  end

  test "valid without abbreviation" do
    marker = valid_marker
    marker.abbreviation = nil
    assert marker.valid?
  end

  test "invalid with abbreviation longer than 10 characters" do
    marker = valid_marker
    marker.abbreviation = "A" * 11
    assert_not marker.valid?
    assert marker.errors[:abbreviation].any?
  end

  test "valid with abbreviation at max length" do
    marker = valid_marker
    marker.abbreviation = "A" * 10
    assert marker.valid?
  end

  test "valid without description" do
    marker = valid_marker
    marker.description = nil
    assert marker.valid?
  end

  test "invalid with description longer than 100 characters" do
    marker = valid_marker
    marker.description = "A" * 101
    assert_not marker.valid?
    assert marker.errors[:description].any?
  end

  test "valid with description at max length" do
    marker = valid_marker
    marker.description = "A" * 100
    assert marker.valid?
  end

  test "valid without min_reference_value" do
    marker = valid_marker
    marker.min_reference_value = nil
    assert marker.valid?
  end

  test "valid without max_reference_value" do
    marker = valid_marker
    marker.max_reference_value = nil
    assert marker.valid?
  end

  test "valid without both reference values" do
    marker = valid_marker
    marker.min_reference_value = nil
    marker.max_reference_value = nil
    assert marker.valid?
  end

  test "min_reference_value must be >= 0" do
    marker = valid_marker
    marker.min_reference_value = -1
    assert_not marker.valid?
    assert marker.errors[:min_reference_value].any?
  end

  test "min_reference_value of 0 is valid" do
    marker = valid_marker
    marker.min_reference_value = 0
    marker.max_reference_value = 1
    assert marker.valid?
  end

  test "valid with min less than max" do
    marker = valid_marker
    marker.min_reference_value = 10
    marker.max_reference_value = 20
    assert marker.valid?
  end

  test "invalid with max less than min" do
    marker = valid_marker
    marker.min_reference_value = 20
    marker.max_reference_value = 10
    assert_not marker.valid?
    assert marker.errors[:max_reference_value].any?
  end

  test "invalid with max less than min when max has a higher leading digit" do
    marker = valid_marker
    marker.min_reference_value = 10
    marker.max_reference_value = 9
    assert_not marker.valid?
    assert marker.errors[:max_reference_value].any?
  end

  test "invalid with max equal to min" do
    marker = valid_marker
    marker.min_reference_value = 10
    marker.max_reference_value = 10
    assert_not marker.valid?
    assert marker.errors[:max_reference_value].any?
  end

  test "enum unit accepts all defined values" do
    BioMarker.units.each_key do |unit|
      marker = valid_marker
      marker.name = "Marker #{unit}"
      marker.unit = unit
      assert marker.valid?, "expected #{unit} to be a valid unit"
    end
  end

  test "fixtures are valid" do
    assert bio_markers(:glucose).valid?
    assert bio_markers(:hemoglobin).valid?
  end
end
