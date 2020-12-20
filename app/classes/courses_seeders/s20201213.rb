module CoursesSeeders
  class S20201213
    FACULTIES = [
      '宝宝老师',
      '苗苗老师',
      'Serena老师',
      'Mia老师'
    ].freeze

    FACULTY_EMAIL_MAPPER = {
      '宝宝老师' => 'Miss BaoBao',
      '苗苗老师' => 'Miss MiaoMiao',
      'Serena老师' => 'Miss Serena',
      'Mia老师' => 'Miss Mia'
    }

    SPECIALTIES = {
      1 => ['Chinese', '基础汉语1班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      2 => ['Chinese', '基础汉语2班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      3 => ['Chinese', '基础汉语3班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      4 => ['Chinese', '基础汉语4班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      5 => ['Chinese', '基础汉语5班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      6 => ['Chinese', '基础汉语6班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      7 => ['Chinese', '基础汉语7班（简体字)', '听说读写', '基础汉语课程由Alpha Beta Academy自主开发设计的课程。从偏旁部首入手，导入字、词、句的练习，以及汉字的书写。课后配有字卡练习，汉字书写练习，以及绘本阅读。虽然定义为基础汉语，但是当这套课程学完以后，孩子会成为中国通。中文听说、文字阅读、中国文化通晓，一网打尽。'],
      8 => ['Chinese', '基础汉语复习课1班（简体字)', '听说读写', '基础汉语复习课是《基础汉语》课的巩固和延展。由老师带领孩子完成基础汉语课后初中高级的词汇练习，节省家长课后陪同练习的时间。让孩子带着乐趣复习，加深对词语的理解和认知。'],
      9 => ['Chinese', '基础汉语复习课2班（简体字)', '听说读写', '基础汉语复习课是《基础汉语》课的巩固和延展。由老师带领孩子完成基础汉语课后初中高级的词汇练习，节省家长课后陪同练习的时间。让孩子带着乐趣复习，加深对词语的理解和认知。'],
      10 => ['Chinese', '跟着小栗子学中文1班', '听说读写', '课程注重听力理解、阅读理解、词汇认读、汉字书写。教导孩子父子有亲，兄妹有情，朋友有信，家中有爱。与基础汉语课最大的区别是提升到了短文阅读，短文内容随动画主题而定。'],
      11 => ['Chinese', '跟着小栗子学中文2班', '听说读写', '课程注重听力理解、阅读理解、词汇认读、汉字书写。教导孩子父子有亲，兄妹有情，朋友有信，家中有爱。与基础汉语课最大的区别是提升到了短文阅读，短文内容随动画主题而定。'],
      12 => ['Chinese', '写字课', '写字练习', '写字的生字选择来源于基础汉语课上的初中高级词汇。通过对汉字的拆分，帮助孩子理解汉字的结构和组合。书写简单汉字和多笔画汉字。通过写字练习加强孩子对生词的认知，实现肌肉记忆。写字课重点讲授字的结构、正确的笔顺，培养孩子正确的握笔姿势和写字坐姿。并让孩子感受中国文字的美感。本课程提供现场课和录播课。'],
      13 => ['Dance', '舞蹈课（仅限ABA中文的学生)', '舞蹈基本功', 'ABA合作波士顿CJTDream舞蹈工作室。以中国舞作为主题教学，帮助孩子提升省体柔韧度、灵活性、四肢协调性，培养孩子对中国音乐和舞蹈的艺术熏陶。'],
      14 => ['Chinese', '说说唱唱学中文1班', '听说读写', ''],
      15 => ['Chinese', '说说唱唱学中文2班', '听说读写', '']
    }

    KLASSES = {
      'Chinese - 基础汉语1班（简体字) - 宝宝老师' => ['CHN-100S', 1500, 6250, 'Zoom', 25, 'Mon', '23:00', '55', 18],
      'Chinese - 基础汉语2班（简体字) - 宝宝老师' => ['CHN-200S', 1500, 6250, 'Zoom', 25, 'Tue', '23:00', '55', 18],
      'Chinese - 基础汉语3班（简体字) - 宝宝老师' => ['CHN-300S', 1500, 6250, 'Zoom', 25, 'Wed', '00:00', '55', 18],
      'Chinese - 基础汉语4班（简体字) - 宝宝老师' => ['CHN-400S', 1500, 6250, 'Zoom', 25, 'Thu', '23:00', '55', 18],
      'Chinese - 基础汉语5班（简体字) - 宝宝老师' => ['CHN-500S', 1500, 6250, 'Zoom', 25, 'Fri', '00:00', '55', 18],
      'Chinese - 基础汉语6班（简体字) - 宝宝老师' => ['CHN-600S', 1500, 6250, 'Zoom', 25, 'Sat', '23:00', '55', 18],
      'Chinese - 基础汉语7班（简体字) - 苗苗老师' => ['CHN-700S', 1500, 6250, 'Zoom', 25, 'Sun', '18:00', '55', 18],
      'Chinese - 基础汉语复习课1班（简体字) - 苗苗老师' => ['CHN-800S', 1500, 4500, 'Zoom', 25, 'Wed', '22:45', '60', 18],
      'Chinese - 基础汉语复习课2班（简体字) - 苗苗老师' => ['CHN-900S', 1500, 4500, 'Zoom', 25, 'Fri', '23:30', '60', 18],
      'Chinese - 跟着小栗子学中文1班 - Serena老师' => ['CHN-1010S', 1200, 6000, 'Zoom', 25, 'Sat', '22:00', '60', 24],
      'Chinese - 跟着小栗子学中文2班 - Serena老师' => ['CHN-1020S', 1200, 6000, 'Zoom', 25, 'Sun', '00:00', '60', 24],
      'Chinese - 写字课 - Serena老师' => ['CHN-1030S', 700, 6000, 'Zoom', 25, 'Sun', '18:00', '60', 100],
      'Chinese - 说说唱唱学中文1班 - 苗苗老师' => ['CHN-1040S', 1500, 4500, 'Zoom', 25, 'Mon, Tue, Wed, Thu', '22:00', 55, 12],
      'Chinese - 说说唱唱学中文2班 - 苗苗老师' => ['CHN-1050S', 1500, 4500, 'Zoom', 25, 'Mon, Tue, Wed, Thu', '22:00', 55, 12],
      'Dance - 舞蹈课（仅限ABA中文的学生) - Mia老师' => ['DNC-100S', 1200, 6000, 'Zoom', 25, 'Sun', '19:00', '60', 100]
    }

    VACAYS = {
      'CHN-100S' => ['2021-02-15', '2021-04-05', '2021-06-28'],
      'CHN-200S' => ['2021-02-16', '2021-04-06', '2021-06-29'],
      'CHN-300S' => ['2021-02-17', '2021-04-07', '2021-06-30'],
      'CHN-400S' => ['2021-02-11', '2021-04-08'],
      'CHN-500S' => ['2021-02-12', '2021-04-09'],
      'CHN-600S' => ['2021-01-02', '2021-02-13', '2021-04-10'],
      'CHN-700S' => ['2021-01-03', '2021-02-14', '2021-04-11'],
      'CHN-800S' => ['2021-02-17', '2021-04-07', '2021-06-30'],
      'CHN-900S' => ['2021-01-02', '2021-02-12', '2021-04-09'],
      'CHN-1010S' => ['2021-01-02', '2021-02-13', '2021-04-10'],
      'CHN-1020S' => ['2021-01-03', '2021-02-14', '2021-04-11'],
      'CHN-1030S' => ['2021-01-03', '2021-02-14', '2021-04-11'],
      'CHN-1040S' => ['2020-12-24'],
      'CHN-1050S' => ['2020-12-24'],
      'DNC-100S' => ['2021-01-03', '2021-02-14', '2021-04-11']
    }

    EFFECTIVE_FROM = '2021-01-04'
    EFFECTIVE_UNTIL = '2021-06-27'

    REG_EFFECTIVE_FROM = '2020-12-18'
    REG_EFFECTIVE_UNTIL = '2021-05-15'

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
