class ApplicationController < ActionController::API
  include ErrorResponse::Helper

  before_action :doorkeeper_authorize!

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end
end
