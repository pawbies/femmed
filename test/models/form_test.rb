require "test_helper"

class FormTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert forms(:tablet).valid?
  end

  test "should require a name" do
    form = Form.new(name: nil)
    assert_not form.valid?
    assert_includes form.errors[:name], "can't be blank"
  end

  test "should require a unique name" do
    duplicate = Form.new(name: forms(:tablet).name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
