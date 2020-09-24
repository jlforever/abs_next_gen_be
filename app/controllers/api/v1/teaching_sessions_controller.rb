module Api
  module V1
    class TeachingSessionsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :student_session_materials, 'Student Session Materials Management'

      swagger_api :student_materials do
        summary 'Faculty manage to upload student class session materials'
        param :header, 'Authorization', :string, :required, 'User procured Acccess Token'
        param :form, 'student_session_material', :formData, :required, 'Uploaded student session material form file'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def student_materials
        begin
          raise 'You\'re not permitted to access this teaching session to perform student uploads' unless permitted_to_access_teching_session?

          teaching_session_student_upload = TeachingSessionStudentMaterialsCreator.create!(
            teaching_session,
            student_session_material.tempfile,
            student_session_material.original_filename,
            student_session_material.content_type
          )

          render json: { teaching_session_student_upload: teaching_session_student_upload.as_serialized_hash }, status: :created
        rescue => exception
          render json: { errors: { student_session_material_creation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def student_session_material
        @student_session_material ||= params.require(:student_session_material)
      end

      def teaching_session
        @teaching_session ||= TeachingSession.find(params[:id])
      end

      def permitted_to_access_teching_session?
        current_user == teaching_session.klass.faculty.user
      end
    end
  end
end
