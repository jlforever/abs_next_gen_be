class TeachingSessionStudentUpload < ApplicationRecord
  belongs_to :teaching_session
  has_many :class_session_materials

  def material_access_url
    S3FileManager.url_for_object(
      teaching_session.klass.materials_holding_folder_name,
      name
    )
  end

  def as_serialized_hash
    {
      id: id,
      teaching_session_id: teaching_session_id,
      material_access_url: material_access_url,
      name: name,
      mime_type: mime_type, 
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
