class AddTeachingSessionStudentUploadIdToClassSessionMaterials < ActiveRecord::Migration[5.2]
  def change
    add_reference :class_session_materials, :teaching_session_student_upload, index: { name: 'idx_class_sessions_on_teaching_session_student_upload' }
  end
end
