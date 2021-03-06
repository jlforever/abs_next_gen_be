class Klass < ApplicationRecord
  belongs_to :specialty
  belongs_to :faculty
  has_many :registrations
  has_many :class_sessions, through: :registrations
  has_many :teaching_sessions
  has_many :klass_vacay_dates

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

  scope :creation_ordered, -> { order(created_at: :asc) }

  scope :reg_effective, -> do
    where(
      '? >= klasses.reg_effective_from AND ? <= klasses.reg_effective_until',
      Time.zone.now, Time.zone.now
    )
  end

  scope :of_personnel_managable, ->(personnel) do
    where(
      'klasses.faculty_id = ?',
      personnel.id
    )
  end

  def capacity_reached?
    available_spots <= 0
  end

  def available_spots
    capacity - registrations.eligible.map(&:number_of_registrants).sum
  end

  def vacay_date_strings
    klass_vacay_dates.map(&:off_date)
  end

  def materials_holding_folder_name
    "#{specialty.subject}_#{specialty.category}_#{faculty.name}_#{effective_from.strftime('%m-%d-%Y')}"
  end

  def occur_on_week_days
    occurs_on_for_a_given_week.split(',').map(&:strip)
  end

  def first_session_date
    first_occur_wod = occur_on_week_days.first
    second_occur_wod = occur_on_week_days.last

    offset_days = (0..14).to_a.detect do |day_increment|
      comparable_date = (effective_from + day_increment.days)

      !vacay_date_strings.include?(comparable_date.strftime('%Y-%m-%d')) &&
        (comparable_date.strftime('%a') == first_occur_wod || comparable_date.strftime('%a') == second_occur_wod)
    end

    effective_from + offset_days.days
  end

  def remaining_session_dates_from_reference_date(referencce_date)
    expected_session_dates.find_all do |date|
      hours_offset, minutes_offset = individual_session_starts_at.split(":").map(&:to_i)
      (date + hours_offset.hours + minutes_offset.minutes) >= referencce_date
    end
  end

  def expected_session_dates
    occur_ons = occur_on_week_days

    (first_session_date.to_date..effective_until.to_date).find_all do |specific_date|
      !vacay_date_strings.include?(specific_date.strftime('%Y-%m-%d')) &&
        occur_ons.include?(specific_date.strftime('%a'))
    end
  end

  def as_serialized_hash
    {
      id: id,
      code: code,
      specialty: {
        subject: specialty.subject,
        category: specialty.category,
        focus_areas: specialty.focus_areas
      },
      faculty: {
        name: faculty.name,
        bio: faculty.bio
      },
      number_of_weeks: number_of_weeks,
      taught_via: taught_via,
      per_session_student_cost: per_session_student_cost,
      occurs_on_for_a_given_week: occurs_on_for_a_given_week,
      individual_session_starts_at: individual_session_starts_at,
      per_session_minutes: per_session_minutes,
      phyiscal_location_address: phyiscal_location_address,
      effective_from: effective_from,
      effective_until: effective_until,
      reg_effective_from: reg_effective_from,
      reg_effective_until: reg_effective_until,
      virtual_klass_platform_link: virtual_klass_platform_link,
      capacity: capacity,
      available_spots: available_spots,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
