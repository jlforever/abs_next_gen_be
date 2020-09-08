class CreateTeachingSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :teaching_sessions do |t|
      t.references :klass, null: false, index: true, foreign_key: true
      t.datetime :effective_for, null: false
      t.text :corresponding_class_session_title

      t.timestamps null: false
    end
  end
end
