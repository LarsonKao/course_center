module Api::V1
  class TeachersController < ApplicationController
    before_action :check_current_teacher!, only: [:update, :show, :destroy]

    def show
      success_response(current_teacher)
    end

    def create
      return error_response(:existing_teacher) if current_user.teacher.present?
      teacher = Teacher.new(create_params)
      current_user.teacher = teacher
      if teacher.save && current_user.save
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
      return error_response(:not_found_teacher) if current_teacher.nil?
    end

    def current_teacher
      current_teacher = current_user.teacher
    end

    def create_params
      params.permit(:lab)
    end

    def update_params
      params.permit(:lab)
    end
  end
end
