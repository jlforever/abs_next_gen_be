class RegistrationCreditCardCharge < ApplicationRecord
  belongs_to :registration
  belongs_to :credit_card

  def as_serialized_hash
    {
      id: id,
      credit_card_id: credit_card_id,
      registration_id: registration_id,
      charge_id: charge_id,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
