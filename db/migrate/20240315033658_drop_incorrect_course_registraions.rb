class DropIncorrectCourseRegistraions < ActiveRecord::Migration[6.1]
  def change
    drop_table :course_registraions
  end
end
