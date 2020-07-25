class CreateClassSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :class_sessions do |t|
      t.references :registration, null: false, index: true, foreign_key: true
      t.text :status, null: false
      t.datetime :effective_for, null: false

      t.timestamps null: false
    end
  end
end
