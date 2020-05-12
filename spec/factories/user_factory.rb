FactoryBot.define do
  sequence(:email) { |sequence_number| "some-email#{sequence_number}@example.com" }

  factory :user do
    email
  end
end
