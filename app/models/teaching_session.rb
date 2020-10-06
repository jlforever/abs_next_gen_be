class TeachingSession < ApplicationRecord
  belongs_to :klass
  has_many :associate_class_sessions, class_name: 'ClassSession', foreign_key: 'associate_teaching_session_id'
  has_many :teaching_session_student_uploads

  delegate :individual_session_starts_at, to: :klass

  def as_serialized_hash
    {
      id: id,
      effective_for: effective_for,
      individual_session_starts_at: individual_session_starts_at,
      corresponding_class_session_title: corresponding_class_session_title,
      teaching_session_student_uploads: teaching_session_student_uploads.map(&:as_serialized_hash),
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
