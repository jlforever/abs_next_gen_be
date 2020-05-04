module Api
  module V1
    class SignUpsController < ApplicationController
      include Concerns::SessionEstablishable

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
        rescue UserCreator::CreationError => exception
          @obtained_user_creation_error = exception.to_s
          false
        end
      end

      def user
        @user ||= begin
          UserCreator.create!(email: user_params[:email], password: user_params[:password])
        end
      end
    end
  end
end
