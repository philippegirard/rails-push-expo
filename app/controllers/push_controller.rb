class PushController < ApplicationController

  def register
    User.create!(register_params)
    render json: { status: 'success', token: register_params[:token] }
  rescue
    render json: { status: 'error', token: 'token is missing or already exists' }, status: 401
  end

  def notif
    user = User.find_by(id: notif_params[:id])
    user = user || User.last

    client = Exponent::Push::Client.new

    messages = [{
      to: user.token,
      sound: "default",
      body: "HELLO DEAR"
    }]

    client.publish messages

    render json: { status: 'success' }
  end

  private

  def notif_params
    params.permit(:id)
  end

  def register_params
    params.permit(:name, :token)
  end
end
