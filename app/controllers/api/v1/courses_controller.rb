module Api
  module V1
    class CoursesController < ApplicationController

      swagger_controller :courses, 'Courses Management'
      swagger_api :index do
        summary 'Retrieving unregistering, effective courses'
        param :query, 'user_email', :string, :required, 'Parent user email'
        param :query, 'perspective', :string, :required, 'User profile perspective (parent|faculty)'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def index
        begin
          requesting_user = if accessor_querying_params[:user_email].present?
            authorize_access_request!

            User.where(email: accessor_querying_params[:user_email]).first.tap do |user|
              raise 'Attempt to retrieve courses, while logged in, via an unauthorized user' unless current_user == user
            end
          end

          courses = CoursesQueryer.find_courses!(user: requesting_user, search_context: search_context)
          render json: { courses: courses.map(&:as_serialized_hash) }, status: :ok
        rescue => exception
          render json: { errors: { courses_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :teaching_sessions do
        summary 'Retrieve course associated teaching session for eligible faculty users'
        param :query, 'id', :integer, :required, 'Course unique identifier'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def teaching_sessions
        authorize_access_request!

        begin
          raise 'Unable to access teaching session as a non faculty user' unless faculty.present?
          raise 'You\'re unable to access teaching session for a course that you do not have access to' if course_faculty_mismatched?

          render json: { teaching_sessions: course.teaching_sessions.map(&:as_serialized_hash) }, status: :ok
        rescue => exception
          render json: { errors: { teaching_sessions_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def faculty
        @faculty ||= current_user.faculty
      end

      def course
        @course ||= Klass.find(params[:id])
      end

      def course_faculty_mismatched?
        course.faculty != faculty
      end

      def accessor_querying_params
        params.permit(:user_email)
      end

      def profile_perspective
        @profile_perspective ||= params[:perspective]
      end

      def search_context
        @search_context ||= begin
          if profile_perspective == 'parent'
            'registration'
          elsif profile_perspective == 'faculty'
            'management'
          else
            'registration'
          end
        end
      end
    end
  end
end
