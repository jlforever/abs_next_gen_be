class TeachingSession < ApplicationRecord
  belongs_to :klass
  has_many :associate_class_sessions, class_name: 'ClassSession', foreign_key: 'associate_teaching_session_id'
  has_many :teaching_session_student_uploads

  def as_serialized_hash
    {
      id: id,
      effective_for: effective_for,
      corresponding_class_session_title: corresponding_class_session_title,
      teaching_session_student_uploads: teaching_session_student_uploads.map(&:as_serialized_hash),
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
