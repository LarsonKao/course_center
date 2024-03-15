module Api::V1
  class StudentsController < ApplicationController
    before_action :check_current_student!, except: [:create]

    def show
      success_response(current_student)
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
      current_student.update(update_params)
      return error_response(:unprocessable_entity_result, {error: current_student.errors.full_messages.join(", ")}) if current_student.errors.present?

      success_response
    end

    def destroy
      current_student.destroy
      return error_response(:unprocessable_entity_result, {error: current_student.errors.full_messages}) if current_student.errors.present?

      success_response
    end

    def register_course
      course = Course.find_by(id: register_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?
      current_student.courses << course
      success_response
    end

    def unregister_course
      course = current_student.courses.find_by(id: unregister_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?

      current_student.courses.delete(course)
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

    def register_course_params
      params.require(:course_id)
      params.permit(:course_id)
    end

    def unregister_course_params
      params.require(:course_id)
      params.permit(:course_id)
    end
  end
end
