FactoryBot.define do
  sequence(:email) { |sequence_number| "some-email#{sequence_number}@example.com" }

  factory :user do
    email
    first_name { 'Tom' }
    last_name { 'Jerry' }
    phone_number { '610-250-9588' }
  end
end
