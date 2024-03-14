module Api::V1
  class StudentsController < ApplicationController
    before_action :set_current_student, only: [:update, :show, :destroy]

    def show
      success_response(@student)
    end

    def create
      return error_response(:existing_student) if current_user.student.present?
      student = Student.new(create_params)
      current_user.student = student
      if student.save && current_user.save
        success_response(student)
      else
        error_response(:unprocessable_entity_result,
        {
          user: current_user.errors.full_messages,
          student: student.errors.full_messages
        })
      end
    end

    def update
      @student.update(update_params)
      return error_response(:unprocessable_entity_result, {error: @student.errors.full_messages.join(", ")}) if @student.errors.present?

      success_response
    end

    def destroy
      @student.destroy
      return error_response(:unprocessable_entity_result, {error: @student.errors.full_messages}) if @student.errors.present?

      success_response
    end

    private

    def set_current_student
      @student = current_user.student
      return head :not_found if @student.nil?
      @student
    end

    def create_params
      params.permit(:status)
    end

    def update_params
      params.permit(:status)
    end
  end
end
