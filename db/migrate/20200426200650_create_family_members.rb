class CreateFamilyMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :family_members do |t|
      t.references :parent, null: false, index: true, foreign_key: true
      t.references :student, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
