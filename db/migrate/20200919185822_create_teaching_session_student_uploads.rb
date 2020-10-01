class CreateTeachingSessionStudentUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :teaching_session_student_uploads do |t|
      t.references :teaching_session, null: false, index: { name: 'idx_ts_student_uploads_on_ts' }, foreign_key: true
      t.text :name, null: false
      t.text :mime_type, null: false

      t.timestamps null: false 
    end
  end
end
