module Api
  module V1
    class UserProfilesController < ApplicationController
      before_action :authorize_access_request!

      def index
        # TBI
      end

      def update
        begin
          UserProfileUpdater.update!(
            user: current_user,
            profile_params: profile_update_params
          )
        rescue UserProfileUpdater::MutationError => exception

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
