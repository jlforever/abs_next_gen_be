module Api
  module V1
    class FamilyMembersController < ApplicationController
      before_action :authorize_access_request!
      
      swagger_controller :family_members, 'Family members management'
      
      swagger_api :create do
        summary 'Creating a family member'
        param :header, 'Authorization', :string, :required, 'Expired Acccess Token'
        param :form, 'student[first_name]', :string, :required, 'Student first name'
        param :form, 'student[last_name]', :string, :required, 'Student last name'
        param :form, 'student[nickname]', :string, :required, 'Student nickname'
        param :form, 'student[date_of_birth]', :string, :required, 'Student date of birth in yyyy-mm-dd format'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def create
        begin
          family_member = FamilyMemberCreator.create!(current_user, student_params)
          render json: { family_member: family_member.as_serialized_hash }, status: :created
        rescue FamilyMemberCreator::CreationError => exception
          render json: { errors: { family_member_creation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def student_params
        params.
          require(:student).
          permit(
            :first_name,
            :last_name,
            :nickname,
            :date_of_birth
          )
      end
    end
  end
end
