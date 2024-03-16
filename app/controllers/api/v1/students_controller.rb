module Api::V1
  class StudentsController < ApplicationController
    before_action :check_current_student!, except: [:create, :index]
    skip_before_action :doorkeeper_authorize!, only: [:index]

    def index
      result = Student.all.map do |t|
        {
          name: t.user.name,
          email: t.user.email,
          status: t.status
        }
      end
      success_response(result)
    end

    def show
      result = {
        user_id: current_student.user.id,
        student_id: current_student.id,
        name: current_student.user.name,
        email: current_student.user.email,
        status: current_student.status
      }
      success_response(result)
    end

    def create
      return error_response(:existing_student) if current_user.student.present?
      student = Student.new(create_params)
      current_user.student = student
      if current_user.save
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
      unless current_student.update(update_params)
        return error_response(:unprocessable_entity_result, {error: current_student.errors.full_messages.join(", ")})
      end
      success_response
    end

    def destroy
      unless current_student.destroy
        return error_response(:unprocessable_entity_result, {error: current_student.errors.full_messages})
      end
      success_response
    end

    private

    def check_current_student!
      error_response(:not_found_student) if current_student.nil?
    end

    def current_student
      @current_student ||= current_user.student
    end

    def create_params
      params.permit(:status)
    end

    def update_params
      params.permit(:status)
    end
  end
end
