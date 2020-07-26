class PaidClassSessionsCreateJob < ApplicationJob
  queue_as :default

  def perform(registration)
    return unless registration.paid?

    registration.klass.expected_session_dates.each do |specific_date|
      registration.class_sessions.create!(
        status: 'upcoming',
        effective_for: specific_date
      )
    end
  end
end
