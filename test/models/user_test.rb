require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:example_user)
  end

  test "name should be present" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "name should be unique" do
    duplicate_user = @user.dup
    duplicate_user.name = @user.name.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = nil
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end
end
