class PaidClassSessionsCreateJob < ApplicationJob
  queue_as :default

  def perform(registration)
    return unless registration.paid?

    registration.klass.remaining_session_dates_from_reference_date(registration.created_at).each do |specific_date|
      associate_teaching_session = registration.klass.teaching_sessions.detect { |ts| ts.effective_for.to_date == specific_date.to_date }

      registration.class_sessions.create!(
        status: 'upcoming',
        effective_for: specific_date + 9.hours,
        associate_teaching_session_id: associate_teaching_session.id
      )
    end
  end

  def self.execute(registration)
    return unless registration.paid?

    registration.klass.remaining_session_dates_from_reference_date(registration.created_at).each do |specific_date|
      associate_teaching_session = registration.klass.teaching_sessions.detect { |ts| ts.effective_for.to_date == specific_date.to_date }

      registration.class_sessions.create!(
        status: 'upcoming',
        effective_for: specific_date + 9.hours,
        associate_teaching_session_id: associate_teaching_session.id
      )
    end
  end
end
