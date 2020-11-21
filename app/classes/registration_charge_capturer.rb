class RegistrationChargeCapturer
  class CaptureError < StandardError; end

  def self.capture!(registration, amount, credit_card)
    new(registration, amount, credit_card).capture!
  end

  def initialize(registration, amount, credit_card)
    @registration = registration
    @amount = amount
    @credit_card = credit_card
  end

  def capture!
    raise 'Unable to pay a registration with an inaccessible credit card' if credit_card_not_accessible?

    ActiveRecord::Base.transaction do
      create_registration_credit_card_charge!.tap do |registration_credit_card_charge|
        stripe_charge_response = Stripe::Charge.create(charge_capture_params)
        registration_credit_card_charge.update!(charge_id: stripe_charge_response[:id], charge_outcome: stripe_charge_response[:outcome])

        RegistrationMailer.registration_confirmation(registration).deliver_now
        RegistrationMailer.aba_admin_registration_notification(registration).deliver_now
      end
    end
  rescue Stripe::CardError,
    Stripe::RateLimitError,
    Stripe::InvalidRequestError,
    Stripe::AuthenticationError,
    Stripe::APIConnectionError,
    Stripe::StripeError => exception

    body = exception.json_body
    err = body[:error]

    error_message = if err[:message]
      err[:type] + ': ' + err[:message]
    else
      err[:type]
    end

    raise CaptureError.new(error_message)
  rescue => exception
    raise CaptureError.new(exception.to_s)
  end

  private

  attr_reader :registration, :amount, :credit_card

  def credit_card_not_accessible?
    credit_card.user != registration.primary_family_member.parent.user 
  end

  def create_registration_credit_card_charge!
    RegistrationCreditCardCharge.create!(
      registration: registration,
      credit_card: credit_card,
      amount: amount,
      charge_id: 'placeholder_charge_id'
    )
  end

  def charge_description
    <<-DESC
      registration_identifier: #{registration.id}
      klass: #{registration.klass.specialty.category}
      student: #{student_names}
      email: #{registration.primary_family_member.parent.user.email}
    DESC
  end

  def student_names
    child_first_name = registration.primary_family_member.student.first_name
    child_last_name = registration.primary_family_member.student.last_name
    second_child_first_name = FamilyMember.where(id: registration.secondary_family_member_id).first&.student&.first_name
    second_child_last_name = FamilyMember.where(id: registration.secondary_family_member_id).first&.student&.last_name
    third_child_first_name = FamilyMember.where(id: registration.tertiary_family_member_id).first&.student&.first_name
    third_child_last_name = FamilyMember.where(id: registration.tertiary_family_member_id).first&.student&.last_name
  
    if third_child_first_name.present?
      "#{@child_first_name} #{@child_last_name} and #{second_child_first_name} #{second_child_last_name} and #{third_child_first_name} #{third_child_last_name}"
    elsif @second_child_first_name.present?
      "#{child_first_name} #{child_last_name} and #{second_child_first_name} #{second_child_last_name}"
    else
      "#{child_first_name} #{child_last_name}"
    end
  end

  def charge_capture_params
    {
      amount: amount,
      currency: 'usd',
      customer: credit_card.stripe_customer_token,
      description: charge_description
    }
  end
end
