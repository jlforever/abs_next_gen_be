FactoryBot.define do
  factory :registration_credit_card_charge do
    registration
    credit_card
    charge_id { 'this_is_a_charge_id' }
    charge_outcome { { result: 'this-is-some-outcome-result' } }
    amount { 200 }
  end
end
