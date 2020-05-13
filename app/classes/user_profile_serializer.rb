class UserProfileSerializer
  def self.serialize(user)
    new(user).serialize
  end

  def initialize(user)
    @user = user
    @parent = user.parent
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
        timezone: user.timezone,
        slug: user.slug,
        parent: {
          address1: parent&.address1,
          address2: parent&.address2,
          city: parent&.city,
          state: parent&.state,
          zip: parent&.zip,
          created_at: parent&.created_at,
          updated_at: parent&.updated_at
        },
        teacher: {}
      }
    }
  end

  private

  attr_reader :user, :parent
end