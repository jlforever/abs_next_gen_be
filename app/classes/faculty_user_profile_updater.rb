class FacultyUserProfileUpdater < BaseUserProfileUpdater
  def initialize(user:, profile_params:)
    super
    @faculty = user.faculty
  end

  private

  attr_reader :faculty

  def assign_context_specific_attributes
    faculty.address1 = address1
    faculty.address2 = address2
    faculty.city = city
    faculty.state = state
    faculty.zip = zip
    faculty.name = faculty_name
    faculty.bio = faculty_bio
  end

  def context_specific_persist!
    faculty.save!
  end

  def extra_params
    [
      :faculty_name,
      :faculty_bio
    ] 
  end
end
