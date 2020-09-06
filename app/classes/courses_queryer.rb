class CoursesQueryer
  class CoursesIdentifyingError < StandardError; end

  def self.find_courses!(user:, search_context: 'registration')
    new(user: user, search_context: search_context).find_courses!
  end

  def initialize(user:, search_context:)
    @user = user
    @search_context = search_context
  end

  def find_courses!
    begin
      if search_context == 'registration'
        identified_parent_eligible_classes!(Klass.reg_effective.creation_ordered)
      elsif search_context == 'management'
        identified_faculty_eligible_classes!
      end
    rescue => exception
      raise CoursesIdentifyingError.new(exception.to_s)
    end
  end

  private

  attr_reader :user, :search_context

  def identified_parent_eligible_classes!(classes)
    if parent
      classes.find_all { |course| !parent_user_registered_courses.include?(course) }
    else
      classes
    end
  end

  def identified_faculty_eligible_classes!
    if faculty
      Klass.effective.of_personnel_managable(faculty)
    else
      raise 'Unable to find management based courses, without a logged in faculty'
    end
  end

  def parent
    @parent_user ||= user&.parent
  end

  def faculty
    @faculty ||= user&.faculty
  end

  def parent_user_registered_courses
    @parent_user_registered_courses ||= begin
      registrations = Registration.not_failed.of_parent_user(parent.user)
      registrations.map(&:klass)
    end
  end
end
