Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users, only: %i[show create destroy update] do
      end

      resource :user, only: %i[show] do
      end

      resource :teachers, only: %i[create update destroy] do
        collection do
          get '', action: :index
        end
      end

      resource :teacher, only: %i[show] do
      end

      resource :students, only: %i[create update destroy] do
        collection do
          get '', action: :index
        end
      end

      resource :student, only: %i[show] do
      end

      resource :courses, only: %i[create update destroy] do
        collection do
          get '', action: :index
          post 'assign_course', action: :assign_course
          post 'unassign_course', action: :unassign_course
          get 'assign_course_list', action: :assign_course_list
          get 'register_course_list', action: :register_course_list
          get 'student_list', action: :student_list
          post 'register_course', action: :register_course
          post 'unregister_course', action: :unregister_course
        end
      end

      resource :course, only: %i[show] do
      end
    end
  end

  #doorkeeper
  post '/login', to: 'doorkeeper/tokens#create'
  post '/logout', to: 'doorkeeper/tokens#revoke'
end
