class Registration < ApplicationRecord
  VALID_STATUSES = ['pending', 'paid', 'overdue', 'failed', 'passed']

  belongs_to :klass
  belongs_to :primary_family_member, class_name: 'FamilyMember', foreign_key: 'primary_family_member_id'
  has_many :class_sessions
  has_one :registration_credit_card_charge

  validates :primary_family_member_id,
    :klass_id,
    :status,
    presence: true

  validates :status, inclusion: { in: VALID_STATUSES }

  scope :not_failed, -> { where('registrations.status <> ?', 'failed') }
  scope :eligible, -> { where('registrations.status not in (?)', ['failed', 'passed']) }
  scope :of_parent_user, ->(parent_user) do
    joins('
      left outer join family_members as first_member on first_member.id = registrations.primary_family_member_id
      left outer join parents as first_member_parent on first_member_parent.id = first_member.parent_id
      left outer join users as first_member_parent_user on first_member_parent_user.id = first_member_parent.user_id
    ').where('lower(first_member_parent_user.email) = ?', parent_user.email.downcase)
  end

  delegate :individual_session_starts_at, to: :klass

  VALID_STATUSES.each do |valid_status|
    define_method :"#{valid_status}?" do
      status == valid_status
    end
  end

  def paid!
    ActiveRecord::Base.transaction do
      self.status = 'paid'
      save!

      PaidClassSessionsCreateJob.execute(self)
    end
  end

  def number_of_registrants
    [
      primary_family_member_id,
      secondary_family_member_id,
      tertiary_family_member_id
    ].compact.count
  end

  def passed?
    status == 'passed' 
  end

  def as_serialized_hash
    {
      id: id,
      course: klass.as_serialized_hash,
      accept_release_form: accept_release_form,
      status: status,
      primary_family_member_id: primary_family_member_id,
      secondary_family_member_id: secondary_family_member_id,
      tertiary_family_member_id: tertiary_family_member_id,
      total_due: total_due,
      total_due_by: total_due_by,
      handling_fee: handling_fee,
      subtotal: subtotal,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
