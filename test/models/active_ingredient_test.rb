require "test_helper"

class ActiveIngredientTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert active_ingredients(:methylphenidate).valid?
  end

  test "should require a name" do
    ingredient = ActiveIngredient.new(name: nil)
    assert_not ingredient.valid?
    assert_includes ingredient.errors[:name], "can't be blank"
  end

  test "should require a unique name" do
    duplicate = ActiveIngredient.new(name: active_ingredients(:methylphenidate).name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "should allow nil half_life" do
    ingredient = ActiveIngredient.new(name: "Testamine", half_life: nil)
    assert ingredient.valid?
  end

  test "should store half_life as a float" do
    assert_instance_of Float, active_ingredients(:methylphenidate).half_life
  end
end
