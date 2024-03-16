class ApplicationController < ActionController::API
  include ErrorResponse::Helper

  before_action :doorkeeper_authorize!

  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  private
  def render_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
