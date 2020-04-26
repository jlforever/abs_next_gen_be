class CreateFaculties < ActiveRecord::Migration[5.2]
  def change
    create_table :faculties do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.text :bio, null: false

      t.timestamps null: false
    end
  end
end
