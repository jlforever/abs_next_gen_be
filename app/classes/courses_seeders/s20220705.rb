module CoursesSeeders
  class S20220705
    FACULTIES = [
      'Serena老师'
    ].freeze


    FACULTY_EMAIL_MAPPER = {
      'Serena老师' => 'Miss Serena'
    }.freeze

    SPECIALTIES = {
      1 => ['Chinese', '西游记私塾', '听说读写', '西游记私塾是Alpha Beta Academy自主开发设计的课程。课程注重听力理解、阅读理解、词汇认读、汉字书写。与基础汉语课最大的区别是提升到了短文阅读，短文内容随动画主题而定。']
    }

    KLASSES = {
      'Chinese - 西游记私塾 - Serena老师' => ['CHN-960-SU22', 2500, 6250, 'Zoom', 9, 'Sun', '15:30', '55', 7]
    }

    EFFECTIVE_FROM = '2022-07-09 09:00:00'
    EFFECTIVE_UNTIL = '2022-09-05'

    REG_EFFECTIVE_FROM = '2022-07-05'
    REG_EFFECTIVE_UNTIL = '2022-08-31'

    VACAYS = {
    }.freeze

    def self.seed!
      new.seed!
    end

    def seed!
      ActiveRecord::Base.transaction do
        seed_faculties_if_necessary!
        seed_specialties_if_necessary!
        seed_klasses_if_necessary!
        seed_vacay_days!
      end
    end

    private

    attr_reader :faculties, :specialties

    def seed_vacay_days!
      VACAYS.each do |class_code, vacay_dates|
        klass = Klass.where(code: class_code).first
        vacay_dates.each do |date|
          KlassVacayDate.where(
            klass_id: klass.id,
            off_date: date
          ).first_or_create!
        end
      end
    end

    def seed_faculties_if_necessary!
      FACULTIES.each do |faculty_name|
        email_heading = FACULTY_EMAIL_MAPPER[faculty_name]
        email = "#{email_heading.parameterize}@alphabetaacademy.com"
        user = User.where(email: email).first_or_initialize

        if user.new_record?
          user.password = 'aeious12345!'
          user.slug = nil
          user.save!
        end

        Faculty.where(name: faculty_name, user: user, bio: 'Experienced Teacher').first_or_create!
      end
    end

    def seed_specialties_if_necessary!
      SPECIALTIES.each do |_, specialty_values|
        subject, category, focus_areas, description = specialty_values
        specialty = Specialty.where(
          subject: subject,
          category: category,
          focus_areas: focus_areas
        ).first_or_create!

        specialty.description = description
        specialty.save!
      end
    end

    def seed_klasses_if_necessary!
      KLASSES.each do |specialty_teacher, klass_values|
        subject, category, teacher_name = specialty_teacher.split('-').map(&:strip)
        class_code, student_per_session, teacher_pay, taught_via, number_of_weeks, occurs_on, session_starts_at, per_session_length, capacity = klass_values     

        specialty = Specialty.where(subject: subject, category: category).first
        faculty = Faculty.where(name: teacher_name).first

        Klass.where(
          code: class_code,
          capacity: capacity,
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
          reg_effective_from: Time.zone.parse(REG_EFFECTIVE_FROM),
          reg_effective_until: Time.zone.parse(REG_EFFECTIVE_UNTIL),
          one_sibling_same_class_discount_rate: 50.0,
          two_siblings_same_class_discount_rate: 50.0
        ).first_or_create!
      end
    end
  end
end
