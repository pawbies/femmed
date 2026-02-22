require "test_helper"

class AssistentTalkTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    assert assistent_talks(:alice_introduction).valid?
  end

  test "should require a user" do
    talk = AssistentTalk.new(talk: :introduction)
    assert_not talk.valid?
    assert_includes talk.errors[:user], "must exist"
  end

  test "should require a talk" do
    talk = AssistentTalk.new(user: users(:alice))
    assert_not talk.valid?
    assert_includes talk.errors[:talk], "can't be blank"
  end

  test "should have introduction enum value" do
    assert assistent_talks(:alice_introduction).introduction?
  end
end
