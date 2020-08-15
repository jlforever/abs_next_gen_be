class PaidClassSessionsCreateJob < ApplicationJob
  queue_as :default

  def perform(registration)
    return unless registration.paid?

    registration.klass.remaining_session_dates_from_reference_date(registration.created_at).each do |specific_date|
      registration.class_sessions.create!(
        status: 'upcoming',
        effective_for: specific_date
      )
    end
  end
end
