class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :days, array: true, default: []
      t.integer :credit, null: false, default: 1
      t.timestamps
    end
  end
end
