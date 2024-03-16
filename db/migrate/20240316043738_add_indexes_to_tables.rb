class AddIndexesToTables < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :name
    add_index :courses, :name
    add_index :teachers, :lab
    add_index :students, :status
  end
end
