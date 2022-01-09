desc 'seed the June 2020 to Aug 2020, specialty, faculty, klass'
task seed_june_2020_to_aug_2020_specialty_faculty_and_klass_data: :environment do
  CoursesSeeders::S20200606.seed!
end

desc 'seed the Aug 2020 to Oct 2020, specialty, faculty, klass'
task seed_aug_2020_to_oct_2020_specialty_faculty_klass_data: :environment do
  CoursesSeeders::S20200814.seed!
end

desc 'seed the Nov 2020 to Dec 2020, specialty, faculty, klass'
task seed_nov_2020_to_dec_2020_specialty_faculty_klass_data: :environment do
  CoursesSeeders::S20201010.seed!
end

desc 'seed the June 2021 to Aug 2021 specialty, faculty, klassese'
task seed_nov_2020_to_dec_2020_specialty_faculty_klass_data: :environment do
  CoursesSeeders::S20210605.seed!
end

desc 'seed th feb 2022 to jun 2022 specialty, faculty, and klasses'
task seed_feb_2022_to_jun_2022_specialty_faculty_klass_data: :environment do
  CoursesSeeders::S20220107.seed!
end
