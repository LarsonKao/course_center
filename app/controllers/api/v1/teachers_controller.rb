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

    private

    def create_params
      params.permit(:lab)
    end
  end
end
