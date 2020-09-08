class TeachingSession < ApplicationRecord
  belongs_to :klass
  has_many :associate_class_sessions, class_name: 'ClassSession', foreign_key: 'associate_teaching_session_id'
end
