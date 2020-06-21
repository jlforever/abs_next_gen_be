class CoursesQueryer
  def self.find_courses(user: user)
    new(user: user).find_courses
  end

  def initialize(user: user)
    @user = user
  end

  def find_courses
    classes = Klass.effective

    if parent.present?
      classes = classes.find_all { |course| !parent_user_registered_courses.include?(course) }
    end

    classes
  end

  private

  attr_reader :user

  #def family_members
  #  user&.parent&.family_members 
  #end

  def parent
    @parent_user ||= user&.parent
  end

  def parent_user_registered_courses
    @parent_user_registered_courses ||= begin
      registrations = Registration.not_failed.of_parent_user(parent.user)
      registrations.map(&:klass)
    end
  end
end
