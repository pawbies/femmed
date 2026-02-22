require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert users(:alice).valid?
  end

  test "should require an email address" do
    user = User.new(username: "test", password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should require a unique email address" do
    duplicate = User.new(email_address: users(:alice).email_address, username: "other", password: "password")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "should require a username" do
    user = User.new(email_address: "test@example.com", password: "password")
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "should normalize email address to lowercase" do
    user = users(:alice)
    user.email_address = "ALICE@EXAMPLE.COM"
    user.save
    assert_equal "alice@example.com", user.email_address
  end

  test "should have user role by default" do
    assert users(:alice).user?
  end

  test "should support admin role" do
    users(:alice).admin!
    assert users(:alice).admin?
  end

  test "should have a valid pfp enum value" do
    assert users(:alice).medicine_kisser?
  end

  test "should return profile_picture path" do
    assert_match /pfps\/.*\.png/, users(:alice).profile_picture
  end
end
