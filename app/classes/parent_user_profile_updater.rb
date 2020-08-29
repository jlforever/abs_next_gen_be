class ParentUserProfileUpdater < BaseUserProfileUpdater
  def initialize(user:, profile_params:)
    super
    @parent = user.parent
  end

  private

  attr_reader :parent

  def assign_context_specific_attributes
    parent.address1 = address1
    parent.address2 = address2
    parent.city = city
    parent.state = state
    parent.zip = zip
    parent.emergency_contact = emergency_contact
    parent.emergency_contact_phone_number = emergency_contact_phone_number
  end

  def context_specific_persist!
    parent.save! 
  end

  def extra_params
    [
      :emergency_contact,
      :emergency_contact_phone_number
    ]
  end
end
