require "test_helper"

class LabelerTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert labelers(:pfizer).valid?
  end

  test "should require a name" do
    labeler = Labeler.new(name: nil)
    assert_not labeler.valid?
    assert_includes labeler.errors[:name], "can't be blank"
  end

  test "should require a unique name" do
    duplicate = Labeler.new(name: labelers(:pfizer).name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
