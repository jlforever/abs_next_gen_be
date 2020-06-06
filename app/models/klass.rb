class Klass < ApplicationRecord
  belongs_to :specialty
  belongs_to :faculty
  has_many :registrations

  validates :specialty_id,
    :faculty_id,
    :taught_via,
    :number_of_weeks,
    :occurs_on_for_a_given_week,
    :individual_session_starts_at,
    :per_session_minutes,
    :effective_from,
    :effective_until,
    presence: true

  scope :effective, -> do
    where(
      '? >= klasses.effective_from AND ? <= klasses.effective_until',
      Time.zone.now, Time.zone.now
    )
  end

  scope :eligible_for_family_members, ->(family_members) do
    family_member_ids = family_members.map(&:id).join(',')
    sql = <<-SQL
      SELECT klasses.id
      FROM klasses left join registrations on registrations.klass_id = klasses.id
      WHERE (registrations.id is null) OR
        (
          registrations.status <> 'failed' AND
          registrations.primary_family_member_id not in (#{family_member_ids}) AND
          registrations.secondary_family_member_id not in (#{family_member_ids}) AND
          registrations.tertiary_family_member_id not in (#{family_member_ids})
        )
    SQL

    ids = ActiveRecord::Base.connection.execute(sql).field_values('id')
    where(id: ids)
  end
end
