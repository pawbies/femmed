require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert categories(:stimulants).valid?
  end

  test "should require a name" do
    category = Category.new(name: nil)
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "should require a unique name" do
    duplicate = Category.new(name: categories(:stimulants).name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
