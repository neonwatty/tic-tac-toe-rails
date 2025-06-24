require "test_helper"

class SessionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @session = Session.new(user: @user)
  end

  test "valid session is valid" do
    assert @session.valid?
  end

  test "requires user association" do
    @session.user = nil
    assert_not @session.valid?
  end

  test "association works" do
    @session.save!
    assert_equal @user, @session.reload.user
  end
end 