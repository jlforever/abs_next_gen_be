FactoryBot.define do
  factory :parent do
    user

    trait :with_full_address do
      address1 { '109 Sunset Dr' }
      address2 { 'Suite 109' }
      city { 'New Berlin' }
      state { 'TX' }
      zip { '35959' }
    end
  end
end
