module Api
  module V1
    class AuthenticationRenewalsController < ApplicationController
      before_action :authorize_refresh_by_access_request!

      swagger_controller :authentication_renewals, 'Authentication Renewals (refreshes) Management'

      swagger_api :create do
        summary 'Re-obtain an authentication access token'
        param :header, 'Authorization', :string, :required, 'Expired Acccess Token'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def create
        session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
        tokens  = session.refresh_by_access_payload
        render json: tokens.slice(:access, :access_expires_at), status: :created
      end
    end
  end
end
