class BaseUserProfileUpdater
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

  PROFILE_ADDRESS_ACCESS_PARAMS = [
    :address1,
    :address2,
    :city,
    :state,
    :zip
  ]

  ELIGIBLE_EXTRA_PARAMS = [
    :faculty_name,
    :faculty_bio
  ]

  def initialize(user:, profile_params:)
    @user = user

    (USER_PROFILE_ACCESS_PARAMS.concat(PROFILE_ADDRESS_ACCESS_PARAMS).concat(extra_params)).each do |param|
      self.send "#{param}=", profile_params[param]
    end
  end

  def self.update!(user:, profile_params:)
    new(user: user, profile_params: profile_params).update!
  end

  def update!
    begin
      raise "The user name #{user_name} has already been taken" if user_name_not_unqiue?
      raise 'You must provide your first and last name' unless name_available?
      raise 'You must provide your phone number' unless phone_number_available?
      raise 'You must provide your address' unless address_parts_all_available?

      assign_user_attributes
      assign_context_specific_attributes

      ActiveRecord::Base.transaction do
        user.save!
        context_specific_persist!
        reset_user_slug!

        user
      end
    rescue => exception
      raise MutationError.new(exception.to_s)
    end
  end

  private

  attr_reader :user
  attr_accessor *(
    USER_PROFILE_ACCESS_PARAMS.concat(
      PROFILE_ADDRESS_ACCESS_PARAMS
    ).concat(ELIGIBLE_EXTRA_PARAMS)
  )

  def user_name_not_unqiue?
    user.user_name != user_name &&
      User.where(user_name: user_name).present?
  end

  def phone_number_available?
    phone_number.present?
  end

  def name_available?
    first_name.present? && last_name.present?
  end

  def address_parts_all_available?
    address1.present? &&
      city.present? &&
      state.present? &&
      zip.present?
  end

  def reset_user_slug!
    user.slug = nil
    user.save!
  end

  def assign_user_attributes
    user.first_name = first_name
    user.last_name = last_name
    user.user_name = user_name
    user.phone_number = phone_number
    user.emergency_contact = emergency_contact
    user.emergency_contact_phone_number = emergency_contact_phone_number
    user.timezone = timezone
  end

  def assign_context_specific_attributes
    raise NotImplementedError
  end

  def extra_params
    raise NotImplementedError
  end
end
