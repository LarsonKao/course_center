class ChangeTeacherAttributes < ActiveRecord::Migration[6.1]
  def change
    rename_column :teachers, :fab, :lab
  end
end
