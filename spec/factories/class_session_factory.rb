FactoryBot.define do
  factory :class_session do
    registration
    effective_for { Time.now }
    status { 'upcoming' }
  end
end
