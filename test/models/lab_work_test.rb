require "test_helper"

class LabWorkTest < ActiveSupport::TestCase
  test "valid with required attributes" do
    lab_work = LabWork.new(user: users(:alice), taken_at: Time.current)
    assert lab_work.valid?
  end

  test "invalid without taken_at" do
    lab_work = LabWork.new(user: users(:alice))
    assert_not lab_work.valid?
    assert_includes lab_work.errors[:taken_at], "can't be blank"
  end

  test "invalid without user" do
    lab_work = LabWork.new(taken_at: Time.current)
    assert_not lab_work.valid?
    assert_includes lab_work.errors[:user], "must exist"
  end

  test "belongs to user" do
    lab_work = lab_works(:lab_work)
    assert_equal users(:alice), lab_work.user
  end

  test "has rich text notes" do
    lab_work = lab_works(:lab_work)
    lab_work.notes = "Cholesterol normal, vitamin D low"
    lab_work.save!
    assert_equal "Cholesterol normal, vitamin D low", lab_work.notes.to_plain_text
  end
end
