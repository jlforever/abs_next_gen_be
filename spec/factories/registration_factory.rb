FactoryBot.define do
  factory :registration do
    klass
    primary_family_member factory: [:family_member]
    
    status { 'pending' }
    total_due { 200 }
    total_due_by { 5.days.from_now }

    trait :paid do
      status { 'paid' }
    end

    trait :failed do
      status { 'failed' }
    end

    trait :overdue do
      status { 'overdue' }
    end
  end
end