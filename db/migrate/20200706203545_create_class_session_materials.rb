class CreateClassSessionMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :class_session_materials do |t|
      t.references :class_session, null: false, index: true, foreign_key: true
      t.text :name, null: false
      t.text :audience, null: false
      t.text :mime_type

      t.timestamps null: false
    end
  end
end
