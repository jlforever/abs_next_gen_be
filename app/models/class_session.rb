class ClassSession < ApplicationRecord
  VALID_STATUSES = ['upcoming', 'active', 'passed']

  belongs_to :registration
  has_many :materials, class_name: 'ClassSessionMaterial', foreign_key: 'class_session_id'
  belongs_to :associate_teaching_session, class_name: 'TeachingSession', foreign_key: 'associate_teaching_session_id'

  validates :registration_id, :effective_for, :status, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }

  delegate :individual_session_starts_at, to: :registration

  def as_serialized_hash
    {
      id: id,
      status: status,
      effective_for: effective_for,
      student_materials: student_specific_materials.map(&:as_serialized_hash),
      teacher_materials: teacher_specific_materials.map(&:as_serialized_hash),
      individual_session_starts_at: individual_session_starts_at,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def student_specific_materials
    materials.find_all do |material|
      material.audience == 'students'
    end
  end

  def teacher_specific_materials
    materials.find_all do |material|
      material.audience == 'teacher'
    end
  end
end
