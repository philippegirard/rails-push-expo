require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "name is required" do
    user = User.new
    user.name = nil
    refute_predicate user, :valid?
  end

  test "name has default value" do
    user = User.new
    user.token = 'something'
    assert_predicate user, :valid?
  end

  test "token is required" do
    user = User.new
    user.token = nil
    refute_predicate user, :valid?
  end

  test "token is unique" do
    user = users(:phil)
    new_user = User.new(token: user.token)
    refute_predicate new_user, :valid?
  end
end
