module Api::V1
  class TeachersController < ApplicationController
    def create
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
      teqacher = current_user.teacher
      return error_response(:not_found, {error: 'not found teacher'}) if teqacher.nil?
      teqacher.update(update_params)
      return error_response(:unprocessable_entity_result, {error: teqacher.errors.full_messages.join(", ")}) if current_user.errors.present?

      success_response
    end

    private

    def create_params
      params.permit(:lab)
    end

    def update_params
      params.permit(:lab)
    end
  end
end
