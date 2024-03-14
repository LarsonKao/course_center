class CreateTeachers < ActiveRecord::Migration[6.1]
  def change
    create_table :teachers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :fab

      t.timestamps
    end
  end
end
