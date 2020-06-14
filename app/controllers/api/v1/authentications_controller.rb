module Api
  module V1
    class AuthenticationsController < ApplicationController
      include Concerns::SessionEstablishable

      swagger_controller :authentications, 'Authentications Management'

      swagger_api :create do
        summary 'Obtain an authentication access token'
        param :form, 'user[email]', :string, :required, 'Email Address'
        param :form, 'user[password]', :string, :required, 'Password'
        response :unauthorized
        response :created
      end

      def create
        Rails.logger.info "hello I am in initialize place of authentication"
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
