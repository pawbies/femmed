require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "should be valid with a user" do
    session = Session.new(user: users(:alice))
    assert session.valid?
  end

  test "should require a user" do
    session = Session.new
    assert_not session.valid?
    assert_includes session.errors[:user], "must exist"
  end

  test "should belong to a user" do
    session = users(:alice).sessions.create!
    assert_equal users(:alice), session.user
  end

  test "should be destroyed when user is destroyed" do
    user  = users(:alice)
    count = user.sessions.count
    user.sessions.create!
    assert_difference "Session.count", -(count + 1) do
      user.destroy
    end
  end
end
