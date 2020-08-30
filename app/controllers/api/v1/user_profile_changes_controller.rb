module Api
  module V1
    class UserProfileChangesController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :user_profile_changes, 'User Profile Changes Management'
      swagger_api :create do
        summary 'Creating (updating) user profiles'
        param :header, 'Authorization', :string, :required, 'Expired Acccess Token'
        param :form, 'perspective', :string, :required, 'User profile perspective (parent|faculty)'
        param :form, 'profile[first_name]', :string, :required, 'User first name'
        param :form, 'profile[last_name]', :string, :required, 'User last name'
        param :form, 'profile[user_name]', :string, :required, 'User screen user name'
        param :form, 'profile[phone_number]', :string, :required, 'User phone number'
        param :form, 'profile[emergency_contact]', :string, :optional, 'User emergency contact'
        param :form, 'profile[emergency_contact_phone_number]', :string, :optional, 'User emergency contact phone number'
        param :form, 'profile[timezone]', :string, :optional, 'User timezone'
        param :form, 'profile[address1]', :string, :optional, 'User address1'
        param :form, 'profile[address2]', :string, :optional, 'User address2'
        param :form, 'profile[city]', :string, :optional, 'User city'
        param :form, 'profile[state]', :string, :optional, 'User state'
        param :form, 'profile[zip]', :string, :optional, 'User zip'
        param :form, 'profile[faculty_name]', :string, :optional, 'Faculty user name'
        param :form, 'profile[faculty_bio]', :string, :optional, 'Faculty user bio'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def create
        begin
          updater_domain_klass.update!(
            user: current_user,
            profile_params: profile_update_params
          )

          render json: UserProfileSerializer.serialize(current_user.reload), status: :created
        rescue BaseUserProfileUpdater::MutationError => exception
          render json: { errors: { profile_mutation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def updater_domain_klass
        @updater_domain_klass ||= begin
          if profile_perspective == 'parent'
            ParentUserProfileUpdater
          elsif profile_perspective == 'faculty'
            FacultyUserProfileUpdater
          else
            ParentUserProfileUpdater
          end
        end
      end

      def profile_perspective
        @profile_perspective ||= params[:perspective]
      end

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
            :zip,
            :faculty_name,
            :faculty_bio
          )
      end
    end
  end
end
