module Api
  module V1
    class ClassSessionsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :class_sessions, 'Class sessions management'

      swagger_api :show do
        summary 'Returns a specific class session data'
        param :query, 'id', :integer, :required, 'unique identifier of the class session'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def show
        begin
          raise 'Unable to retrieve the specific class session, you do not have access to it' if unauthorized_access?

          render json: { class_session: class_session.as_serialized_hash }, status: :ok
        rescue => exception
          render json: { errors: { class_session_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      def class_session
        @class_session ||= ClassSession.find(params[:id])
      end

      def unauthorized_access?
        class_session.registration.primary_family_member.parent.user != current_user
      end
    end
  end
end
