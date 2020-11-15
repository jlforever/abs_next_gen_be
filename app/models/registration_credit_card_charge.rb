class RegistrationCreditCardCharge < ApplicationRecord
  belongs_to :registration
  belongs_to :credit_card

  def as_serialized_hash
    {
      id: id
    }
  end
end
