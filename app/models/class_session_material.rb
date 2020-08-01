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
end
