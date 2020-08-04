module Api
  module V1
    class PasswordResetRequestsController < ApplicationController
      def create
        begin
          user = User.find_by(email: user_email)
          raise 'There is no matching user for the email you\'ve provided' if user.blank?

          user.generate_password_reset_token!
          AccessbilityMailer.request_for_password_reset(user).deliver_now

          head :created
        rescue => exception
          render json: { errors: { password_reset_request_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def user_email
        params.require(:reset_request).permit(:user_email) 
      end
    end
  end
end
