FactoryBot.define do
  sequence(:email) { |sequence_number| "some-email#{sequence_number}@example.com" }

  factory :user do
    email
    first_name { 'Tom' }
    last_name { 'Jerry' }
    phone_number { '610-250-9588' }
    address1 { '109 Sunset Dr' }
    address2 { 'Suite 109' }
    city { 'New Berlin' }
    state { 'TX' }
    zip { '35959' }
  end
end
