Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resource :users, only: %i[show create destroy update] do
      end

      resource :user, only: %i[show] do
      end

      resource :teachers, only: %i[show create update destroy] do
        collection do
          post 'assign_course', action: :assign_course
          delete 'unassign_course', action: :unassign_course
        end
      end

      resource :teacher, only: %i[show] do
      end

      resource :students, only: %i[create update destroy] do
        collection do
          post 'register_course', action: :register_course
          delete 'unregister_course', action: :unregister_course
        end
      end

      resource :student, only: %i[show] do
      end

      resource :courses, only: %i[create update destroy] do
        collection do
          get '', action: :index
        end
      end

      resources :courses, only: %i[show] do
      end
    end
  end

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users

end
