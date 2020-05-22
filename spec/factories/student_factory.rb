FactoryBot.define do
  factory :student do
    first_name { 'Hank' }
    last_name { 'Newson' }
    nickname { 'gl' }
    date_of_birth { Time.zone.parse('2015-06-17') }
  end
end
