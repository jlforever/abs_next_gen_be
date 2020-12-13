class PostRegistrationNotifier
  def self.notify(registration)
    new(registration).notify
  end

  def initialize(registration)
    @registration = registration
  end

  def notify
    if registration_paid?
      send_paid_notification_to_parent_user
    else
      send_unpaid_notification_to_parent_user
    end

    RegistrationMailer.aba_admin_registration_notification(registration).deliver_now
  end

  private

  attr_reader :registration

  def registration_paid?
    registration.paid?
  end

  def send_paid_notification_to_parent_user
    RegistrationMailer.registration_with_fees_paid_confirmation(registration).deliver_now
  end

  def send_unpaid_notification_to_parent_user
    RegistrationMailer.registration_confirmation(registration).deliver_now
  end
end
