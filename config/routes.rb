Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resource :users, only: %i[show create destroy update] do
        collection do
        end
      end

      resource :teachers, only: %i[create] do
        collection do
        end
      end
    end
  end

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users

end
