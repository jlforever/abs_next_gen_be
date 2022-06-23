module CoursesSeeders
  class S20220622
    FACULTIES = [
      '宝宝老师',
      '苗苗老师',
      'Serena老师',
      'Sarah老师'
    ].freeze

    FACULTY_EMAIL_MAPPER = {
      '宝宝老师' => 'Miss BaoBao',
      '苗苗老师' => 'Miss MiaoMiao',
      'Serena老师' => 'Miss Serena',
      'Mia老师' => 'Miss Mia',
      'Sarah老师' => 'Miss Sarah'
    }.freeze

    SPECIALTIES = {
      1 => ['Chinese', '基础汉语1班（快班/大班)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      2 => ['Chinese', '基础汉语2班（慢班/小班)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      4 => ['Chinese', '基础汉语5班（快班/大班)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      5 => ['Chinese', '基础汉语6班（慢班/小班)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。']
    }.freeze

    KLASSES = {
      'Chinese - 基础汉语1班（快班/大班) - 宝宝老师' => ['CHN-100-SU22', 2500, 6250, 'Zoom', 5, 'Mon', '22:00', '55', 7],
      'Chinese - 基础汉语2班（慢班/小班) - 苗苗老师' => ['CHN-200-SU22', 2500, 6250, 'Zoom', 8, 'Tue', '22:00', '55', 7],
      'Chinese - 基础汉语5班（快班/大班) - 宝宝老师' => ['CHN-500-SU22', 2500, 6250, 'Zoom', 5, 'Thu', '23:00', '55', 7],
      'Chinese - 基础汉语6班（慢班/小班) - 苗苗老师' => ['CHN-600-SU22', 2500, 6000, 'Zoom', 8, 'Sat', '21:00', '55', 7],
    }.freeze

    VACAYS = {
    }.freeze

    EFFECTIVE_FROM = '2022-06-28 09:00:00'
    EFFECTIVE_UNTIL = '2022-08-01'

    REG_EFFECTIVE_FROM = '2022-06-23'
    REG_EFFECTIVE_UNTIL = '2022-07-28'

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
