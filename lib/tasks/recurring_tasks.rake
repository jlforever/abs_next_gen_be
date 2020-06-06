desc 'seed the June 2020 to Aug 2020, specialty, faculty, klass'
task seed_june_2020_to_aug_2020_specialty_faculty_and_klass_data: :environment do
  CoursesSeeders::S20200606.seed!
end