class Course < ApplicationRecord
  has_many :course_assignments, dependent: :destroy
  has_many :teachers, through: :course_assignments
  has_many :course_registrations, dependent: :destroy
  has_many :students, through: :course_registrations
end
