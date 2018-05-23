require 'test_helper'

class PushControllerTest < ActionDispatch::IntegrationTest

  test "#register is routable" do
    assert_generates push_register_path, controller: 'push', action: 'register'
  end

  test "#register creates a new user from params" do
    param_name = 'philippe girard'
    param_token = 'the-token'

    assert_difference 'User.count', 1 do
      post push_register_path, params: { name: param_name, token: param_token }
    end

    assert_response :success
    assert_equal param_token, _response[:token]

    user = User.last
    assert_equal param_name, user.name
    assert_equal param_token, user.token
  end

  test "#register creates new user when name is not present" do
    param_token = 'the-token'

    assert_difference 'User.count', 1 do
      post push_register_path, params: { token: param_token }
    end

    assert_response :success
    assert_equal param_token, _response[:token]

    user = User.last
    assert_equal 'philippe girard', user.name
    assert_equal param_token, user.token
  end

  test "#register fails when the token is not provided" do

    assert_no_difference 'User.count' do
      post push_register_path
    end

    assert_response :error
  end

  private

  def _response
    JSON.parse(response.body).with_indifferent_access
  end
end
