class ClassSession < ApplicationRecord
  VALID_STATUSES = ['upcoming', 'active', 'passed']

  belongs_to :registration

  validates :registration_id, :effective_for, :status, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }

  delegate :individual_session_starts_at, to: :registration

  def as_serialized_hash
    {
      id: id,
      status: status,
      effective_for: effective_for,
      individual_session_starts_at: individual_session_starts_at,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
