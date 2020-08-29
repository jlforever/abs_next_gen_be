class UserProfileSerializer
  def self.serialize(user)
    new(user).serialize
  end

  def initialize(user)
    @user = user
    @parent = user.parent
    @faculty = user.faculty
  end

  def serialize
    {
      profile: {
        email: user.email,
        user_name: user.user_name,
        slug: user.slug,
        first_name: user.first_name,
        phone_number: user.phone_number,
        last_name: user.last_name,
        emergency_contact: user.emergency_contact,
        emergency_contact_phone_number: user.emergency_contact_phone_number,
        address1: user.address1,
        address2: user.address2,
        city: user.city,
        state: user.state,
        zip: user.zip,
        timezone: user.timezone,
        slug: user.slug,
        parent: {
          address1: parent&.address1,
          address2: parent&.address2,
          city: parent&.city,
          state: parent&.state,
          zip: parent&.zip,
          emergency_contact: parent&.emergency_contact,
          emergency_contact_phone_number: parent&.emergency_contact_phone_number,
          created_at: parent&.created_at,
          updated_at: parent&.updated_at
        },
        faculty: {
          address1: faculty&.address1,
          address2: faculty&.address2,
          city: faculty&.city,
          state: faculty&.state,
          zip: faculty&.zip,
          faculty_name: faculty&.name,
          faculty_bio: faculty&.bio,
          created_at: faculty&.created_at,
          updated_at: faculty&.updated_at
        }
      }
    }
  end

  private

  attr_reader :user, :parent, :faculty
end