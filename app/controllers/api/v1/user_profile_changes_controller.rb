module Api
  module V1
    class UserProfileChangesController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :user_profile_changes, 'User Profile Changes Management'
      swagger_api :create do
        summary 'Creating (updating) user profiles'
        param :header, 'Authorization', :string, :required, 'Expired Acccess Token'
        param :form, 'profile[first_name]', :string, :required, 'Email Address'
        param :form, 'profile[last_name]', :string, :required, 'Password'
        param :form, 'profile[user_name]', :string, :required, 'Email Address'
        param :form, 'profile[phone_number]', :string, :required, 'Password'
        param :form, 'profile[emergency_contact]', :string, :required, 'Email Address'
        param :form, 'profile[emergency_contact_phone_number]', :string, :required, 'Password'
        param :form, 'profile[timezone]', :string, :required, 'Email Address'
        param :form, 'profile[address1]', :string, :required, 'Password'
        param :form, 'profile[address2]', :string, :required, 'Email Address'
        param :form, 'profile[city]', :string, :required, 'Password'
        param :form, 'profile[state]', :string, :required, 'Email Address'
        param :form, 'profile[zip]', :string, :required, 'Password'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def create
        begin
          UserProfileUpdater.update!(
            user: current_user,
            profile_params: profile_update_params
          )

          render json: UserProfileSerializer.serialize(current_user.reload), status: :created
        rescue UserProfileUpdater::MutationError => exception
          render json: { errors: { profile_mutation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def profile_update_params
        params.
          require(:profile).
          permit(
            :first_name,
            :last_name,
            :user_name,
            :phone_number,
            :emergency_contact,
            :emergency_contact_phone_number,
            :timezone,
            :address1,
            :address2,
            :city,
            :state,
            :zip
          )
      end
    end
  end
end
