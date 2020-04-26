class CreateParents < ActiveRecord::Migration[5.2]
  def change
    create_table :parents do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.text :address, null: false

      t.timestamps null: false
    end
  end
end
