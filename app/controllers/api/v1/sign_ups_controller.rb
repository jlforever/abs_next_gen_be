module Api
  module V1
    class SignUpsController < ApplicationController
      include Concerns::SessionEstablishable

      swagger_controller :sign_ups, 'Sign Ups Management'

      swagger_api :create do
        summary 'Enable a user to sign up'
        param :form, 'user[email]', :string, :required, 'Email Address'
        param :form, 'user[password]', :string, :required, 'Password'
        response :internal_server_error
        response :created
      end

      def create
        obtain_session_and_recognize_errors! do
          render json: { errors: { user_create_error: @obtained_user_creation_error } }, status: :internal_server_error
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password) 
      end

      def user_permitted_for_session_access?
        begin
          user.present?
        rescue ParentUserCreator::CreationError => exception
          @obtained_user_creation_error = exception.to_s
          false
        end
      end

      def user
        @user ||= begin
          ParentUserCreator.create!(email: user_params[:email], password: user_params[:password])
        end
      end
    end
  end
end
