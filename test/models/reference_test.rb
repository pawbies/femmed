require "test_helper"

class ReferenceTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert references(:methylphenidate_wikipedia).valid?
  end

  test "should require a name" do
    reference = Reference.new(url: "https://example.com")
    assert_not reference.valid?
    assert_includes reference.errors[:name], "can't be blank"
  end

  test "should require a unique name" do
    duplicate = Reference.new(name: references(:methylphenidate_wikipedia).name, url: "https://example.com")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "should require a url" do
    reference = Reference.new(name: "Some Reference")
    assert_not reference.valid?
    assert_includes reference.errors[:url], "can't be blank"
  end
end
