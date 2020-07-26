class ClassSession < ApplicationRecord
  VALID_STATUSES = ['upcoming', 'active', 'passed']

  belongs_to :registration

  validates :registration_id, :effective_for, :status, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }

  delegate :individual_session_starts_at, to: :registration
end
