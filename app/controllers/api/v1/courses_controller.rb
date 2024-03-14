module Api::V1
  class CoursesController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: [:show]
    before_action :permission_check!, only: [:update, :create, :destroy]
    before_action :check_course!, only: [:update, :show, :destroy]

    def show
      success_response(current_course)
    end

    def create
      course = Course.new(create_params)

      if course.save
        success_response(course)
      else
        error_response(:unprocessable_entity_result,
        {
          user: current_user.errors.full_messages,
          course: course.errors.full_messages
        })
      end
    end

    def update
      current_course.update(update_params)
      return error_response(:unprocessable_entity_result, {error: current_course.errors.full_messages.join(", ")}) if current_course.errors.present?

      success_response
    end

    def destroy
      current_course.destroy
      return error_response(:unprocessable_entity_result, {error: current_course.errors.full_messages}) if current_course.errors.present?

      success_response
    end

    private

    def permission_check!
      error_response(:create_course_forbidden) if current_user.teacher.nil?
    end

    def check_course!
      error_response(:not_found_course) if current_course.nil?
    end

    def current_course
      params.require(:id)
      @current_course ||= Course.find_by(id: params[:id])
    end

    def create_params
      require_params = [:name, :start_time, :end_time, :days, :credit]
      params.permit(require_params)
    end

    def update_params
      params.permit(:name, :start_time, :end_time, :days, :credit)
    end
  end
end
