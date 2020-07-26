class ClassSessionMaterials < ApplicationRecord
  belongs_to :class_session

  validates :name,
    :class_session_id,
    :audience,
    :mime_type,
    presence: true
end
