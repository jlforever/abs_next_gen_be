module Api
  module V1
    class TeachingSessionStudentUploadsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :teaching_session_student_uploads, 'Teaching Session Student Uploads Management'

      swagger_api :destroy do
        summary 'Deletes student upload and the associated class session materials'
        param :header, 'Authorization', :string, :required, 'User procured Acccess Token'
        param :query, 'teaching_session_id', :integer, :required, 'teaching session unique identifier'
        param :query, 'id', :integer, :required, 'teaching session student upload unique identifier'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def destroy
        begin
          raise 'You\'re not permitted to access this teaching session to perform student uploads' unless permitted_to_access_teching_session?
          raise 'The to be deleted student upload and the accessing teaching session are mismatched' if teaching_session_and_student_upload_not_matching?

          upload = TeachingSessionStudentUploadDestroyer.destroy!(student_upload)
          render json: { teaching_session_student_upload: upload.as_serialized_hash }, status: :ok
        rescue => exception
          render json: { errors: { delete_teaching_session_student_upload_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def permitted_to_access_teching_session?
        current_user == teaching_session.klass.faculty.user
      end

      def teaching_session_and_student_upload_not_matching?
        student_upload.teaching_session != teaching_session
      end

      def teaching_session
        @teaching_session ||= TeachingSession.find(params[:teaching_session_id])
      end

      def student_upload
        @student_upload ||= TeachingSessionStudentUpload.find(params[:id])
      end
    end
  end
end
