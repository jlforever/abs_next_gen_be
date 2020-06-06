module CoursesSeeders
  class S20200606
    FACULTIES = [
      'Miss Gabby',
      'Miss BaoBao'
    ].freeze

    SPECIALTIES = {
      1 => ['Chinese', 'Basic Chinese 1', 'Dictation, Reading'],
      2 => ['Spanish', 'Intro Spanish 1', 'Speaking, Listening']
    }.freeze

    KLASSES = {
      'Chinese - Basic Chinese 1 - Miss BaoBao' => [1500, 6000, 'Zoom', 9, 'TUES, THURS', '10:00 Eastern', '45'],
      'Spanish - Intro Spanish 1 - Miss Gabby' => [2000, 4000, 'Zoom', 9, 'MON', '18:30 Eastern', '45']
    }.freeze

    EFFECTIVE_FROM = '2020-06-29'
    EFFECTIVE_UNTIL = '2020-08-29'

    def self.seed!
      new.seed!
    end

    def seed!
      ActiveRecord::Base.transaction do
        seed_faculties_if_necessary!
        seed_specialties_if_necessary!
        seed_klasses_if_necessary!
      end
    end

    private

    attr_reader :faculties, :specialties

    def seed_faculties_if_necessary!
      FACULTIES.each do |faculty_name|
        email = "#{faculty_name.parameterize}@alphabetaacademy.com"
        user = User.where(email: email).first_or_initialize

        if user.new_record?
          user.password = 'aeious12345!'
          user.save!
        end

        Faculty.where(name: faculty_name, user: user, bio: 'Experienced Teacher').first_or_create!
      end
    end

    def seed_specialties_if_necessary!
      SPECIALTIES.each do |_, specialty_values|
        subject, category, focus_areas = specialty_values
        Specialty.where(
          subject: subject,
          category: category,
          focus_areas: focus_areas
        ).first_or_create!
      end
    end

    def seed_klasses_if_necessary!
      KLASSES.each do |specialty_teacher, klass_values|
        subject, category, teacher_name = specialty_teacher.split('-').map(&:strip)
        student_per_session, teacher_pay, taught_via, number_of_weeks, occurs_on, session_starts_at, per_session_length = klass_values     

        specialty = Specialty.where(subject: subject, category: category).first
        faculty = Faculty.where(name: teacher_name).first

        Klass.where(
          specialty_id: specialty.id,
          faculty_id: faculty.id,
          per_session_student_cost: student_per_session,
          per_session_faulty_cut: teacher_pay,
          taught_via: taught_via,
          number_of_weeks: number_of_weeks,
          occurs_on_for_a_given_week: occurs_on,
          individual_session_starts_at: session_starts_at,
          per_session_minutes: per_session_length,
          effective_from: Time.zone.parse(EFFECTIVE_FROM),
          effective_until: Time.zone.parse(EFFECTIVE_UNTIL),
          one_sibling_same_class_discount_rate: 50.0,
          two_siblings_same_class_discount_rate: 50.0
        ).first_or_create!
      end
    end
  end
end
