class TeachingSession < ApplicationRecord
  belongs_to :klass
  has_many :associate_class_sessions, class_name: 'ClassSession', foreign_key: 'associate_teaching_session_id'

  def as_serialized_hash
    {
      id: id,
      effective_for: effective_for,
      corresponding_class_session_title: corresponding_class_session_title,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
