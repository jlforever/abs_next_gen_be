class CoursesQueryer
  def self.find_courses(user: user)
    new(user: user).find_courses
  end

  def initialize(user: user)
    @user = user
  end

  def find_courses
    classes = Klass.effective.tap do |classes|
    
    if family_members.present?
      classes = classes.eligible_for_family_members(family_members)
    end

    classes
  end

  private

  attr_reader :user

  def family_members
    user&.parent.family_members 
  end
end
