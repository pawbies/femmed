require "test_helper"

class BloodPressureReadingTest < ActiveSupport::TestCase
  def valid_reading
    BloodPressureReading.new(
      user: users(:alice),
      systolic: 120,
      diastolic: 80,
      bpm: 72
    )
  end

  test "valid with all attributes" do
    assert valid_reading.valid?
  end

  test "valid without bpm" do
    reading = valid_reading
    reading.bpm = nil
    assert reading.valid?
  end

  test "valid without measured_at" do
    reading = valid_reading
    reading.measured_at = nil
    assert reading.valid?
  end

  test "invalid without systolic" do
    reading = valid_reading
    reading.systolic = nil
    assert_not reading.valid?
    assert_includes reading.errors[:systolic], "can't be blank"
  end

  test "invalid without diastolic" do
    reading = valid_reading
    reading.diastolic = nil
    assert_not reading.valid?
    assert_includes reading.errors[:diastolic], "can't be blank"
  end

  test "invalid without user" do
    reading = valid_reading
    reading.user = nil
    assert_not reading.valid?
  end

  test "systolic must be greater than 10" do
    reading = valid_reading
    reading.systolic = 10
    assert_not reading.valid?
    assert reading.errors[:systolic].any?
  end

  test "systolic must be less than 350" do
    reading = valid_reading
    reading.systolic = 350
    assert_not reading.valid?
    assert reading.errors[:systolic].any?
  end

  test "diastolic must be greater than 10" do
    reading = valid_reading
    reading.diastolic = 10
    assert_not reading.valid?
    assert reading.errors[:diastolic].any?
  end

  test "diastolic must be less than 350" do
    reading = valid_reading
    reading.diastolic = 350
    assert_not reading.valid?
    assert reading.errors[:diastolic].any?
  end

  test "bpm must be greater than 10 when present" do
    reading = valid_reading
    reading.bpm = 10
    assert_not reading.valid?
    assert reading.errors[:bpm].any?
  end

  test "bpm must be less than 300 when present" do
    reading = valid_reading
    reading.bpm = 300
    assert_not reading.valid?
    assert reading.errors[:bpm].any?
  end

  test "belongs to user" do
    reading = blood_pressure_readings(:normal)
    assert_equal users(:alice), reading.user
  end
end
