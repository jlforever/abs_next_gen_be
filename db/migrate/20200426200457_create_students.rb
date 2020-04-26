class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :nickname, null: false
      t.datetime :date_of_birth, null: false
      t.bigint :age

      t.timestamps null: false
    end
  end
end
