class PushController < ApplicationController

  def register
    User.create!(permitted_params)
    render json: { status: 'success', token: permitted_params[:token] }
  rescue
    render json: { status: 'error', token: '' }, status: 500
  end

  private

  def permitted_params
    params.permit(:name, :token)
  end
end
