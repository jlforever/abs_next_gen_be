module CoursesSeeders
  class S20201010
    FACULTIES = [
      '宝宝老师',
      'MoMo老师',
      'Serena老师'
    ].freeze

    FACULTY_EMAIL_MAPPER = {
      '宝宝老师' => 'Miss BaoBao',
      'MoMo老师' => 'Miss MoMo',
      'Serena老师' => 'Miss Serena'
    }.freeze

    SPECIALTIES = {
      1 => ['Chinese', '基础汉语1班（简体字) 4到7岁', '听说读写'],
      2 => ['Chinese', '基础汉语2班（简体字) 4到7岁', '听说读写'],
      3 => ['Chinese', '基础汉语3班（简体字) 4到7岁', '听说读写'],
      4 => ['Chinese', '基础汉语4班（简体字) 4到7岁', '听说读写'],
      5 => ['Chinese', '基础汉语5班（简体字) 7岁以上', '听说读写'],
      6 => ['Chinese', '基础汉语6班（简体字) 7岁以上', '听说读写'],
      7 => ['Chinese', '基础汉语复习课1班（简体字)', '听说读写'],
      8 => ['Chinese', '基础汉语复习课2班（简体字)', '听说读写'],
      9 => ['Chinese', '跟着小栗子学中文1班', '听说读写'],
      10 => ['Chinese', '跟着小栗子学中文2班', '听说读写'],
      11 => ['Chinese', '写字课', '写字练习']
    }.freeze

    KLASSES = {
      'Chinese - 基础汉语1班（简体字) 4到7岁 - 宝宝老师' => ['CHN-110', 1500, 6250, 'Zoom', 10, 'Mon', '22:00', '60'],
      'Chinese - 基础汉语2班（简体字) 4到7岁 - 宝宝老师' => ['CHN-210', 1500, 6250, 'Zoom', 10, 'Tue', '21:30', '60'],
      'Chinese - 基础汉语3班（简体字) 4到7岁 - 宝宝老师' => ['CHN-310', 1500, 6250, 'Zoom', 10, 'Tue', '22:30', '60'],
      'Chinese - 基础汉语4班（简体字) 4到7岁 - MoMo老师' => ['CHN-410', 1500, 6000, 'Zoom', 10, 'Tue', '19:00', '60'],
      'Chinese - 基础汉语5班（简体字) 7岁以上 - 宝宝老师' => ['CHN-510', 1500, 6250, 'Zoom', 10, 'Thu', '21:30', '60'],
      'Chinese - 基础汉语6班（简体字) 7岁以上 - 宝宝老师' => ['CHN-610', 1500, 6250, 'Zoom', 10, 'Thu', '22:30', '60'],
      'Chinese - 基础汉语复习课1班（简体字) - MoMo老师' => ['CHN-810', 1200, 6000, 'Zoom', 10, 'Thu', '19:00', '45'],
      'Chinese - 基础汉语复习课2班（简体字) - MoMo老师' => ['CHN-910', 1200, 6000, 'Zoom', 10, 'Thu', '20:00', '45'],
      'Chinese - 跟着小栗子学中文1班 - Serena老师' => ['CHN-1010', 1200, 6000, 'Zoom', 10, 'Thu', '20:00', '60'],
      'Chinese - 跟着小栗子学中文2班 - Serena老师' => ['CHN-1020', 1200, 6000, 'Zoom', 10, 'Sat', '21:00', '60'],
      'Chinese - 写字课 - Serena老师' => ['CHN-1030', 500, 6000, 'Zoom', 10, 'Fri', '22:30', '45']
    }.freeze

    EFFECTIVE_FROM = '2020-11-01'
    EFFECTIVE_UNTIL = '2020-12-31'

    REG_EFFECTIVE_FROM = '2020-10-10'
    REG_EFFECTIVE_UNTIL = '2020-12-10'

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
          user.slug = nil
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
