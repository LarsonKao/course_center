module Api::V1
  class UsersController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: [:create]

    def show
      success_response(current_user)
    end

    def create
      client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
      return error_response(:forbidden_client_id) unless client_app

      user = User.new(create_params)

      if user.save
        access_token = Doorkeeper::AccessToken.create(
          resource_owner_id: user.id,
          application_id: client_app.id,
          use_refresh_token: true,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: ''
        )

        success_response(
            id: user.id,
            email: user.email,
            access_token: access_token.token,
            token_type: 'bearer',
            name: user.name
        )
      else
        error_response(:unprocessable_entity_result, {error: user.errors.full_messages})
      end

    end

    def update
      current_user.update(update_params)
      return error_response(:unprocessable_entity_result, {error: current_user.errors.full_messages.join(", ")}) if current_user.errors.present?

      success_response
    end

    def destroy
      current_user.destroy
      return error_response(:unprocessable_entity_result, {error: current_user.errors.full_messages}) if current_user.errors.present?

      success_response
    end

    private

    def create_params
      require_params = [:email, :password, :name]
      params.require(require_params)
      params.permit(require_params)
    end

    def update_params
      params.permit(:name)
    end

    def generate_refresh_token
      loop do
        token = SecureRandom.hex(32)
        break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
      end
    end
  end
end
