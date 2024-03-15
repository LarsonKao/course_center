class Course < ApplicationRecord
  has_many :course_assignments, dependent: :destroy
  has_many :teachers, through: :course_assignments
end
