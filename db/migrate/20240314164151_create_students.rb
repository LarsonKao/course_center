class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 'inactive'

      t.timestamps
    end
  end
end
