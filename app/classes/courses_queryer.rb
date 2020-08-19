class CoursesQueryer
  def self.find_courses(user:, search_context: 'registration')
    new(user: user, search_context: search_context).find_courses
  end

  def initialize(user:, search_context:)
    @user = user
    @search_context = search_context
  end

  def find_courses
    classes = if search_context == 'registration'
      Klass.reg_effective.creation_ordered
    end

    if parent.present?
      classes = classes.find_all { |course| !parent_user_registered_courses.include?(course) }
    end

    classes
  end

  private

  attr_reader :user, :search_context

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
