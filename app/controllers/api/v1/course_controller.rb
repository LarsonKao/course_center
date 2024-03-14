module Api::V1
  class CoursesController < ApplicationController

    def show
      success_response(@course)
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
      @course.update(update_params)
      return error_response(:unprocessable_entity_result, {error: @course.errors.full_messages.join(", ")}) if @course.errors.present?

      success_response
    end

    def destroy
      @course.destroy
      return error_response(:unprocessable_entity_result, {error: @course.errors.full_messages}) if @course.errors.present?

      success_response
    end

    private

    def set_current_course
      @course = current_user.course
      return head :not_found if @course.nil?
      @course
    end

    def create_params
      params.permit(:status)
    end

    def update_params
      params.permit(:status)
    end

  end
end
