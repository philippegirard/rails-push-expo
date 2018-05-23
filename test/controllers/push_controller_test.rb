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

    assert_response :unauthorized
  end

  test "#send is routable" do
    assert_generates push_notif_path, controller: 'push', action: 'notif'
    assert_generates push_notif_path + '/1', controller: 'push', action: 'notif', id: 1
  end

  test "#send send notif to last user when no id is specified" do
    message = [{
      to: User.last.token,
      sound: "default",
      body: "HELLO DEAR"
    }]

    Exponent::Push::Client.any_instance.expects(:publish).once.with(message)

    get push_notif_path

    assert_response :success
    assert_equal 'success', _response[:status]
  end

  test "#send send notif to specfic id when id is specified" do
    user = User.first

    message = [{
      to: user.token,
      sound: "default",
      body: "HELLO DEAR"
    }]

    Exponent::Push::Client.any_instance.expects(:publish).once.with(message)

    get push_notif_path + '/' + user.id.to_s

    assert_response :success
    assert_equal 'success', _response[:status]
  end

  test "#send send notif to lsat user when id does not exists" do
    user = User.first
    id = user.id

    user.destroy

    message = [{
      to: User.last.token,
      sound: "default",
      body: "HELLO DEAR"
    }]

    Exponent::Push::Client.any_instance.expects(:publish).once.with(message)

    get push_notif_path + '/' + id.to_s

    assert_response :success
    assert_equal 'success', _response[:status]
  end

  private

  def _response
    JSON.parse(response.body).with_indifferent_access
  end
end
