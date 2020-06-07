FactoryBot.define do
  factory :specialty do
    subject { 'Chinese' }
    category { 'Level 1 (4-7 years old)' }
    focus_areas { 'Dictation, Reading, Writing'}
    description { 'This is an awesome course' }
  end
end
