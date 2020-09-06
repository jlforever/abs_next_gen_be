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

      private

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
