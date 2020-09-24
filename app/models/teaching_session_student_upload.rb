class TeachingSessionStudentUpload < ApplicationRecord
  belongs_to :teaching_session
  has_many :class_session_materials

  def as_serialized_hash
    {
      id: id,
      teaching_session_id: teaching_session_id,
      name: name,
      mime_type: mime_type, 
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
