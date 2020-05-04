module Api
  module V1
    class AuthenticationsController < ApplicationController
      include Concerns::SessionEstablishable

      def create
        obtain_session_and_recognize_errors! do
          render json: { errors: { user_authentication_error: 'Invalid user' } }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password) 
      end

      def user
        @user ||= User.find_by!(email: user_params[:email])
      end

      def user_permitted_for_session_access?
        user.authenticate(user_params[:password])
      end
    end
  end
end
