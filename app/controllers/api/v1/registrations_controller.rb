module Api
  module V1
    class RegistrationsController < ApplicationController
      before_action :authorize_access_request!

      def create
      end

      def index
      end

      private

      def
      end

      def registration_create_params
        params.
          require(:registration).
          permit(
            :primary_family_member_id,
            :secondary_family_member_id,
            :tertiary_family_member_id
          )
      end
    end
  end
end
