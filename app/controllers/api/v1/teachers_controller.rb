module Api::V1
  class TeachersController < ApplicationController
    before_action :set_current_teacher, only: [:update, :show, :destroy]

    def show
      success_response(@teacher)
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
      @teacher.update(update_params)
      return error_response(:unprocessable_entity_result, {error: @teacher.errors.full_messages.join(", ")}) if @teacher.errors.present?

      success_response
    end

    def destroy
      @teacher.destroy
      return error_response(:unprocessable_entity_result, {error: @teacher.errors.full_messages}) if @teacher.errors.present?

      success_response
    end

    private

    def set_current_teacher
      @teacher = current_user.teacher
      return head :not_found if @teacher.nil?
      @teacher
    end

    def create_params
      params.permit(:lab)
    end

    def update_params
      params.permit(:lab)
    end
  end
end
