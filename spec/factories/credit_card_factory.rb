FactoryBot.define do
  factory :credit_card do
    user
    card_holder_name { 'Allan Smith' }
    card_last_four { '1235' }
    card_type { 'Visa' }
    card_expire_month { '12' }
    card_expire_year { '2023' }
    stripe_customer_token { 'cust_5678nhjo' }
    stripe_card_token { 'card_1234aeiou' }
    postal_identification { '90550' }
  end
end
