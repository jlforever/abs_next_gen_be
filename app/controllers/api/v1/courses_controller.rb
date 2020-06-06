module Api
  module V1
    class CoursesController < ApplicationController
      before_action :authorize_access_request!

      def index
        begin
          requesting_user = if current_user
            User.where(email: parent_course_querying_params[:user_email]).first.tap do |user|
              raise 'Attempt to retrieve courses, while logged in, for unauthorized user' unless current_user == user
            end
          end

          courses = CoursesQueryer.find_courses(user: requesting_user)
        rescue => exception
          render json: { errors: { courses_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def parent_course_querying_params
        params.permit(:user_email)
      end
    end
  end
end
