module Api::V1
  class CoursesController < ApplicationController
    skip_before_action :doorkeeper_authorize!, only: [:show, :index, :assign_course_list]
    before_action :permission_check!, only: [:update, :create, :destroy]
    before_action :check_course!, only: [:update, :show, :destroy, :student_list]

    VALID_KEYS = [1, 2, 3, 4, 5, 6, 7].freeze
    VALID_VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].freeze

    def show
      result = {
        name: current_course.name,
        description: current_course.description,
        credie: current_course.credit,
        schedules: current_course.readable.schedules,
        teachers: current_course.teachers.map do |t|
          {
            name: t.user.name,
            lab: t.lab
          }
        end
      }
      success_response(result)
    end

    def index
      result = Course.all.map do |c|
        readable = c.readable
        {
          name: readable.name,
          description: readable.description,
          credit: readable.credit,
          schedules: readable.schedules,
          teachers: c.teachers.map do |t|
            {
              name: t.user.name,
              lab: t.lab
            }
          end
        }
      end
      success_response(result)
    end

    def create
      return error_response(:invalid_format) unless params[:schedules].present? && check_schedules_format

      course = Course.new(create_params)

      if course.save
        success_response(course.readable)
      else
        error_response(:unprocessable_entity_result,
        {
          user: current_user.errors.full_messages,
          course: course.errors.full_messages
        })
      end
    end

    def update
      return error_response(:invalid_format) if params[:schedules].present? && !check_schedules_format

      unless current_course.update(update_params)
        return error_response(:unprocessable_entity_result, {error: current_course.errors.full_messages.join(", ")})
      end
      success_response
    end

    def destroy
      unless current_course.destroy
        return error_response(:unprocessable_entity_result, {error: current_course.errors.full_messages})
      end
      success_response
    end

    def assign_course
      current_teacher = current_user.teacher
      return error_response(:not_found_teacher) if current_teacher.nil?
      course = Course.find_by(id: assign_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?
      current_teacher.courses << course
      success_response
    end

    def unassign_course
      current_teacher = current_user.teacher
      return error_response(:not_found_teacher) if current_teacher.nil?
      course = current_teacher.courses.find_by(id: unassign_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?
      current_teacher.courses.delete(course)
      success_response
    end

    def assign_course_list
      teacher = Teacher.find_by(id: assign_course_list_params[:teacher_id])
      return error_response(:not_found_teacher) if teacher.nil?
      result = teacher.courses.map(&:readable)
      success_response(result)
    end

    def register_course_list
      student = current_user.student
      return error_response(:not_found_student) if student.nil?
      result = student.courses.map(&:readable)
      success_response(result)
    end

    def student_list
      teacher = current_user.teacher
      return error_response(:not_found_teacher) if teacher.nil?
      return error_response(:not_course_teacher) if current_course.teachers.exclude?(teacher)
      result = current_course.students.map do |s|
        {
          name: s.user.name,
          email: s.user.email,
          status: s.status
        }
      end
      success_response(result)
    end

    def register_course
      current_student = current_user.student
      return error_response(:not_found_student) if current_student.nil?
      course = Course.find_by(id: register_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?
      current_student.courses << course
      success_response
    end

    def unregister_course
      current_student = current_user.student
      return error_response(:not_found_student) if current_student.nil?
      course = current_student.courses.find_by(id: unregister_course_params[:course_id])
      return error_response(:not_found_course) if course.nil?

      current_student.courses.delete(course)
      success_response
    end

    private

    def permission_check!
      error_response(:not_found_teacher) if current_user.teacher.nil?
    end

    def check_course!
      error_response(:not_found_course) if current_course.nil?
    end

    def current_course
      params.require(:id)
      @current_course ||= Course.find_by(id: params[:id])
    end

    def create_params
      require =[:name, :description, :credit]
      params.require(require)
      params.permit(:name, :description, :credit, schedules: {})
    end

    def check_schedules_format

      # 檢查是否為 Hash
      begin
        schedules = params[:schedules].permit!
        unless schedules.is_a?(Hash)
            schedules = schedules.to_hash
        end
      rescue
          return false
      end

      # 檢查 key 是否符合格式
      unless schedules.keys.all? { |key| VALID_KEYS.include?(key.to_i) }
        return false
      end

      # 檢查 value 是否符合格式
      unless schedules.values.flatten.all? { |value| VALID_VALUES.include?(value.to_i) }
        return false
      end

      # 檢查是否有重複的 value
      schedules.each do |key, value|
        unless value.uniq.size == value.size
          return false
        end
      end
      true
    end

    def update_params
      params.permit(:name, :description, :credit, schedules: {})
    end

    def assign_course_params
      params.require(:course_id)
      params.permit(:course_id)
    end

    def unassign_course_params
      params.require(:course_id)
      params.permit(:course_id)
    end

    def assign_course_list_params
      params.require(:teacher_id)
      params.permit(:teacher_id)
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
