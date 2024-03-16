module Api::V1
  class TeachersController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: [:index]
    before_action :check_current_teacher!, except: [:create, :index]

    def index
      result = Teacher.all.map do |t|
        {
          name: t.user.name,
          email: t.user.email,
          lab: t.lab
        }
      end
      success_response(result)
    end

    def show
      result = {
        user_id: current_teacher.user.id,
        teacher_id: current_teacher.id,
        name: current_teacher.user.name,
        email: current_teacher.user.email,
        lab: current_teacher.lab
      }
      success_response(result)
    end

    def create
      return error_response(:existing_teacher) if current_user.teacher.present?
      teacher = Teacher.new(create_params)
      current_user.teacher = teacher
      if current_user.save
        success_response(teacher)
      else
        error_response(:unprocessable_entity_result,
        {
          user: current_user.errors.full_messages,
          teacher: teacher.errors.full_messages
        })
      end
    end

    def update
      current_teacher.update(update_params)
      return error_response(:unprocessable_entity_result, {error: current_teacher.errors.full_messages.join(", ")}) if current_teacher.errors.present?

      success_response
    end

    def destroy
      current_teacher.destroy
      return error_response(:unprocessable_entity_result, {error: current_teacher.errors.full_messages}) if current_teacher.errors.present?

      success_response
    end

    private

    def check_current_teacher!
      error_response(:not_found_teacher) if current_teacher.nil?
    end

    def current_teacher
      @current_teacher ||= current_user.teacher
    end

    def create_params
      params.permit(:lab)
    end

    def update_params
      params.require(:lab)
      params.permit(:lab)
    end
  end
end
