module Api::V1
  class TeachersController < ApplicationController
    before_action :check_current_teacher!, except: [:create]

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

    def assign_course
      course = Course.find_by(id: assign_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?
      current_teacher.courses << course
      success_response
    end

    def unassign_course
      course = current_teacher.courses.find_by(id: unassign_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?

      current_teacher.courses.delete(course)
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
      params.permit(:lab)
    end

    def assign_course_params
      params.require(:course_id)
      params.permit(:course_id)
    end

    def unassign_course_params
      params.require(:course_id)
      params.permit(:course_id)
    end
  end
end
