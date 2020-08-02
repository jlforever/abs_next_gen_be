class ClassSessionMaterial < ApplicationRecord
  belongs_to :class_session

  validates :name,
    :class_session_id,
    :audience,
    :mime_type,
    presence: true

  def material_access_url
    S3FileManager.url_for_object(
      class_session.registration.klass.materials_holding_folder_name,
      name
    )
  end

  def as_serialized_hash
    {
      id: id,
      name: name,
      material_access_url: material_access_url,
      mime_type: mime_type,
      perspective: audience,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
