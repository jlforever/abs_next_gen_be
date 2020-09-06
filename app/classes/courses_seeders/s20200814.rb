module CoursesSeeders
  class S20200814
    FACULTIES = [
      '宝宝老师',
      '优优老师',
      'Angel老师',
      'Miss Tiara',
      'Miss Gabby',
      '馨予老师',
      'Serena老师'
    ].freeze

    FACULTY_EMAIL_MAPPER = {
      '宝宝老师' => 'Miss BaoBao',
      '优优老师' => 'Miss YouYou',
      'Angel老师' => 'Miss Angel',
      'Miss Tiara' => 'Miss Tiara',
      'Miss Gabby' => 'Miss Gabby',
      '馨予老师' => 'Miss XinYu',
      'Serena老师' => 'Miss Serena'
    }.freeze

    SPECIALTIES = {
      1 => ['Chinese', '基础汉语1班（简体字)', '听说读写'],
      2 => ['Chinese', '基础汉语2班（简体字)', '听说读写'],
      3 => ['Chinese', '基础汉语3班（简体字)', '听说读写'],
      4 => ['Chinese', '基础汉语4班（简体字)', '听说读写'],
      5 => ['Chinese', '跟着小栗子学中文1班', '听说读写'],
      6 => ['Chinese', '基础汉语4班（繁体字)', '听说读写'],
      7 => ['Chinese', 'Chinese for English speaking students', 'Speaking, Listening, Writing'],
      8 => ['Spanish', 'Spanish Intro level', 'Speaking, Listening'],
      9 => ['Spanish', 'Spanish Intermediate level', 'Speaking, Listening, Reading,Writing'],
      10 => ['Dance', '儿童舞蹈基本功（民族舞+芭蕾舞)', '舞蹈基本功'],
      11 => ['Arts and Crafts', 'ABA Craft Together', 'Hands on arts and crafts']
    }.freeze

    KLASSES = {
      'Chinese - 基础汉语1班（简体字) - 宝宝老师' => ['CHN-100', 1500, 6000, 'Zoom', 9, 'Mon, Thu', '22:00', '45'],
      'Chinese - 基础汉语2班（简体字) - 宝宝老师' => ['CHN-200', 1500, 6000, 'Zoom', 9, 'Tue, Fri', '22:00', '45'],
      'Chinese - 基础汉语3班（简体字) - 宝宝老师' => ['CHN-300', 1500, 6000, 'Zoom', 9, 'Tue, Fri', '23:00', '45'],
      'Chinese - 基础汉语4班（简体字) - 宝宝老师' => ['CHN-700', 1500, 6000, 'Zoom', 9, 'Tue, Sat', '23:00', '45'],
      'Chinese - 跟着小栗子学中文1班 - 优优老师' => ['CHN-400', 2000, 6000, 'Zoom', 9, 'Mon', '22:30', '60'],
      'Chinese - 基础汉语4班（繁体字) - Angel老师' => ['CHN-500', 1500, 4000, 'Zoom', 9, 'Tue, Fri', '22:30', '45'],
      'Chinese - Chinese for English speaking students - Miss Tiara' => ['CHN-600', 2500, 6000, 'Zoom', 18, 'Tue, Thur', '21:00', '60'],
      'Spanish - Spanish Intro level - Miss Gabby' => ['SPN-100', 2000, 4000, 'Zoom', 9, 'Mon', '21:00', '45'],
      'Spanish - Spanish Intermediate level - Miss Gabby' => ['SPN-200', 2000, 4000, 'Zoom', 9, 'Wed, Fri', '21:00', '45'],
      'Dance - 儿童舞蹈基本功（民族舞+芭蕾舞) - 馨予老师' => ['DNC-100', 2000, 4000, 'Zoom', 9, 'Sat', '13:30', '60'],
      'Arts and Crafts - ABA Craft Together - Serena老师' => ['AC-100', 0, 0, 'Zoom', 9, 'Sat', '18:00', '60']
    }.freeze

    EFFECTIVE_FROM = '2020-08-29'
    EFFECTIVE_UNTIL = '2020-10-31'

    REG_EFFECTIVE_FROM = '2020-08-14'
    REG_EFFECTIVE_UNTIL = '2020-10-20'

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
        email_heading = FACULTY_EMAIL_MAPPER[faculty_name]
        email = "#{email_heading.parameterize}@alphabetaacademy.com"
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
        class_code, student_per_session, teacher_pay, taught_via, number_of_weeks, occurs_on, session_starts_at, per_session_length = klass_values     

        specialty = Specialty.where(subject: subject, category: category).first
        faculty = Faculty.where(name: teacher_name).first

        Klass.where(
          code: class_code,
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
