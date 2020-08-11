module Api
  module V1
    class PasswordResetsController < ApplicationController
      swagger_controller :password_resets, 'Password resetting management'

      swagger_api :edit do
        summary 'Verifies whether the reset token is valid'
        param :query, 'reset_token', :string, :required, 'System generated reset password token'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def edit
        begin
          raise 'Unable to find a user with the specified reset token' if user.blank?
          raise 'Specified reset token has expired' if user.password_reset_token_expires_at < Time.zone.now
        
          head :ok
        rescue => exception
          render json: { errors: { password_reset_token_invalid_error: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :update do
        summary 'Updates a user\'s password to a new one'
        param :query, 'reset_token', :string, :required, 'System generated reset password token'
        param :form, 'password_reset[password]', :string, :required, 'New password'
        param :form, 'password_reset[password_confirmation]', :string, :required, 'New password confirmation'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def update
        begin
          raise 'Unable to find the user to update the new password' if user.blank?
          raise 'You have elapsed the time to update your password, please request a new password reset' if user.password_reset_token_expires_at < Time.zone.now
          raise 'Password and password confirmation are not matching, please try again' if password_reset_params[:password] != password_reset_params[:password_confirmation]

          ActiveRecord::Base.transaction do
            user.password = password_reset_params[:password]
            user.save!
            user.clear_password_reset_token!
          end
          JWTSessions::Session.new(namespace: "user_id_#{user.id}").flush_namespaced

          head :ok
        rescue => exception
          render json: { errors: { password_update_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def reset_token_param
        params.permit(:reset_token)
      end

      def password_reset_params
        params.require(:password_reset).permit(:password, :password_confirmation) 
      end

      def user
        @user ||= User.where(password_reset_token: reset_token_param[:reset_token]).first
      end
    end
  end
end
