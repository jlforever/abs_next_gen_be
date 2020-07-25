FactoryBot.define do
  factory :klass do
    faculty
    specialty
    per_session_student_cost { 2000 }
    per_session_faulty_cut { 6000 }
    taught_via { 'Default' }
    number_of_weeks { 10 }
    occurs_on_for_a_given_week { 'Mon, Wed' }
    individual_session_starts_at { '17:30' }
    per_session_minutes { 45 }
    effective_from { Time.zone.now }
    effective_until { Time.zone.now + 10.weeks }
    one_sibling_same_class_discount_rate { 50.0 }
    two_siblings_same_class_discount_rate { 50.0 }
    virtual_klass_platform_link { 'https://www.zoom.com/123456' }

    trait :virtual_class do
      taught_via { 'Zoom' }
    end

    trait :physical_class do
      taught_via { 'Physical classroom' }
      phyiscal_location_address { '123 News Road, Temple, CA 90099'}
    end
  end
end
