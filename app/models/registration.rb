class Registration < ApplicationRecord
  VALID_STATUSES = ['pending', 'paid', 'overdue', 'failed']

  belongs_to :klass
  belongs_to :primary_family_member, class_name: 'FamilyMember', foreign_key: 'primary_family_member_id'

  VALID_STATUSES.each do |valid_status|
    define_method :"#{valid_status}?" do
      status == valid_status
    end
  end

  scope :not_failed, -> { where('registrations.status <> ?', 'failed') }
end
