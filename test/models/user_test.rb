require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(username: "testuser", email_address: "Test@Example.com ", password: "password", password_confirmation: "password")
  end

  test "valid user is valid" do
    assert @user.valid?
  end

  test "username must be present, unique, and correct length" do
    @user.username = ""
    assert_not @user.valid?
    @user.username = "ab"
    assert_not @user.valid?
    @user.username = "a" * 21
    assert_not @user.valid?
    @user.username = users(:one).username if users(:one).respond_to?(:username)
    assert_not @user.valid? if users(:one).respond_to?(:username)
  end

  test "email_address must be present, unique, and valid format" do
    @user.email_address = ""
    assert_not @user.valid?
    @user.email_address = "invalid-email"
    assert_not @user.valid?
    @user.email_address = users(:one).email_address
    assert_not @user.valid?
  end

  test "email_address is normalized (downcased and stripped)" do
    @user.save!
    assert_equal "test@example.com", @user.reload.email_address
  end

  test "has_secure_password works for authentication" do
    @user.save!
    assert @user.authenticate("password")
    assert_not @user.authenticate("wrongpassword")
  end
end
