module Api
  module V1
    class UserProfilesController < ApplicationController
      class ForbiddenAccessError < StandardError; end
      before_action :authorize_access_request!

      swagger_controller :user_profiles, 'User Profile Retrieval Management'
      swagger_api :index do
        summary 'Retrieve user specific profile info'
        param :query, 'email', :string, required: true
        response :forbidden
        response :ok
      end

      def index
        begin
          raise ForbiddenAccessError.new('You\'re forbidden to access this user profile') if incompatible_user?
          render json: UserProfileSerializer.serialize(current_user), status: :ok
        rescue ForbiddenAccessError => exception
          render json: { errors: { forbidden_to_retrieve_profile_error: exception.to_s } }, status: :forbidden
        end
      end

      private

      def profile_query_params
        params.permit(:email)
      end

      def incompatible_user?
        profile_query_params[:email] != current_user.email 
      end
    end
  end
end
