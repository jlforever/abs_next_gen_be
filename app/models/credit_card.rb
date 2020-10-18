class CreditCard < ApplicationRecord
  belongs_to :user

  validates :card_holder_name,
    :card_last_four,
    :card_type,
    :card_expire_month,
    :card_expire_year,
    presence: true

  def as_serialized_hash
    {
      id: id,
      card_holder_name: card_holder_name,
      card_last_four: card_last_four,
      card_type: card_type,
      card_expire_month: card_expire_month,
      card_expire_year: card_expire_year,
      stripe_customer_token: stripe_customer_token,
      stripe_card_token: stripe_card_token,
      postal_identification: postal_identification,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
