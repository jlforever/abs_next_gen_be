FactoryBot.define do
  factory :teaching_session do
    klass
    effective_for { Time.now }
    corresponding_class_session_title { 'Some Teaching Session' }
  end
end
