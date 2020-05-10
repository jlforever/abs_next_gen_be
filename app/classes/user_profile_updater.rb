class UserProfileUpdater
  class MutationError < StandardError; end

  USER_PROFILE_ACCESS_PARAMS = [
    :first_name,
    :last_name,
    :user_name,
    :phone_number,
    :emergency_contact,
    :emergency_contact_phone_number,
    :timezone
  ]

  PARENT_PROFILE_ACCESS_PARAMS= [
    :address1,
    :address2,
    :city,
    :state,
    :zip
  ]

  def self.update!(user, profile_params)
    new(user, profile_params).update!
  end

  def initialize(user, profile_params)
    @user = user
    @parent = user.parent

    (USER_PROFILE_ACCESS_PARAMS.concat(PARENT_PROFILE_ACCESS_PARAMS)).each do |param|
      self.send "#{param}=", params[param]
    end
  end

  def update!
    begin
      raise "The user name #{user_name} has already been taken" if user_name_not_unqiue?
      raise 'You must provide your first and last name' unless name_available?
      raise 'You must provide your phone number' unless phone_number_available?
      raise 'You must provide your address' unless address_parts_all_available?

      assign_user_attributes
      assign_parent_attributes

      ActiveRecord::Base.transaction do
        user.save!
        parent.save!

        user
      end
    rescue => exception
      MutationError.new(exception.to_s)
    end
  end

  private

  attr_reader :parent, :user
  attr_accessor *(USER_PROFILE_ACCESS_PARAMS.concat(PARENT_PROFILE_ACCESS_PARAMS))

  def user_name_not_unqiue?
    User.where(user_name: user_name).present?
  end

  def name_available?
    first_name.present? && last_name.present?
  end

  def phone_number_available?
    phone_number.present?
  end

  def address_parts_all_available?
    address1.present? &&
      city.present? &&
      state.present? &&
      zip.present?
  end

  def assign_user_attributes
    user.first_name = first_name
    user.last_name = last_name
    user.phone_number = phone_number
    user.emergency_contact = emergency_contact
    user.emergency_contact_phone_number = emergency_contact_phone_number
    user.timezone = timezone
  end

  def assign_parent_attributes
    parent.address1 = address1
    parent.address2 = address2
    parent.city = city
    parent.state = state
    parent.zip = zip
  end
end