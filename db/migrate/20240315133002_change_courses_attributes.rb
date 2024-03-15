class ChangeCoursesAttributes < ActiveRecord::Migration[6.1]
  def change
    remove_column :courses, :days
    remove_column :courses, :start_time
    remove_column :courses, :end_time
    add_column :courses, :schedules, :jsonb, default: [], null: false
  end
end
