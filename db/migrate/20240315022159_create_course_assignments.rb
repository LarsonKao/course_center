class CreateCourseAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :course_assignments do |t|
      t.references :course, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.timestamps
    end
  end
end
