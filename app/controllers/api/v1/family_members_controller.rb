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

      swagger_api :index do
        summary 'Retrieves a parent user\'s family members'
        param  :query, 'user_email', :string, :required, 'Parent user email'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def index
        begin
          identified_parent_user = User.where(email: user_email).first
          raise 'Attempt to retrieve family members with an unauthorized user' unless current_user == identified_parent_user
          render json: { family_members: identified_parent_user.parent.family_members.map(&:as_serialized_hash) }, status: :ok
        rescue => exception
          render json: { errors: { family_member_retrieval_errors: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :destroy do
        summary 'Deletes a parent user\'s family member (student)'
        param :query, 'user_email', :string, :required, 'Parent user email'
        param :query, 'family_member[first_name]', :string, :required, 'Deleting family member student first name'
        param :query, 'family_member[last_name]', :string, :required, 'Deleting family member student last name'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def destroy
        begin
          family_member = FamilyMember.find(params[:id])
          raise 'Attempt to delete a family member with an unauthorized user' unless current_user == family_member&.parent&.user

          ActiveRecord::Base.transaction do
            family_member.destroy
            family_member.student.destroy
          end

          render json: { family_member: family_member.as_serialized_hash }, status: :ok
        rescue => exception
          render json: { errors: { family_member_deletion_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def user_email
        params.require(:user_email)
      end

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
