module Api
  module V1
    class PasswordResetRequestsController < ApplicationController
      swagger_controller :password_resets, 'Password reset request management'

      swagger_api :create do
        summary 'Request to reset password for a user'
        param :form, 'reset_request[user_email]', :string, :required, 'Requesting reset user\'s email'
        response :internal_server_error
        response :created
      end

      def create
        begin
          user = User.where('email ilike ?', "%#{user_email_param[:user_email]}%").first
          raise 'There is no matching user for the email you\'ve provided' if user.blank?

          user.generate_password_reset_token!
          AccessibilityMailer.request_for_password_reset(user).deliver_now

          head :created
        rescue => exception
          render json: { errors: { password_reset_request_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def user_email_param
        params.require(:reset_request).permit(:user_email) 
      end
    end
  end
end
