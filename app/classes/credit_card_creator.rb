class CreditCardCreator
  class CreditCardCreationError < StandardError; end

  def self.create!(user, credit_card_create_params)
    new(user, credit_card_create_params).create!
  end

  def initialize(user, credit_card_create_params)
    @user = user
    @credit_card_create_params = credit_card_create_params
  end

  def create!
    ActiveRecord::Base.transaction do
      stripe_customer = Stripe::Customer.create(
        description: customer_description,
        email: credit_card_owner_email,
        source: credit_card_create_params[:stripe_card_token]
      )

      user.credit_cards.create!(
        credit_card_create_params.merge(
          stripe_customer_token: stripe_customer.id
        )
      )
    end
  rescue => exception
    raise CreditCardCreationError.new("credit_card_create_error: #{exception.to_s}")
  end

  private

  attr_reader :user, :credit_card_create_params

  def customer_description
    @customer_description ||= begin
      <<-DESC
        service: Alpha Beta Academy
        full_name: #{user.first_name}  #{user.last_name}
        phone_number: #{user.phone_number}
        city: #{user.city}
        state: #{user.state}
      DESC
    end
  end

  def credit_card_owner_email
    @credit_card_owner_email ||= user.email
  end
end
