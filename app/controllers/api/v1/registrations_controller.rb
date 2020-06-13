module Api
  module V1
    class RegistrationsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :registrations, 'Registrations Management'

      swagger_api :create do
        summary 'Creating/Registering a class for a set of family members'
        param :header, 'Authorization', :string, :required, 'Expired Acccess Token'
        param :form, 'user_email', :string, :required, 'Parent user email'
        param :form, 'registration[:course_id]', :string, :required, 'Registering class\'s id'
        param :form, 'registration[primary_family_member_id]', :string, :required, 'First registering family member id'
        param :form, 'registration[:secondary_family_member_id]', :string, :optional, 'Second registering family member id'
        param :form, 'registration[:tertiary_family_member_id]', :string, :optional, 'Third registering family member id'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def create
        begin
          raise "Attempt to register with an unauthorized user with email: #{user_email}" if unauthorized_access?

          registration = RegistrationCreator.create!(
            current_user,
            registration_create_params[:course_id],
            family_member1,
            family_member2,
            family_member3
          )
          render json: { registration: registration }, status: :created
        rescue RegistrationCreator::CreationError => exception
          render json: { errors: { registration_creation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      def index
        # TBI
      end

      private

      def unauthorized_access?
        user_email != current_user.email
      end

      def user_email
        params.require(:user_email)
      end

      def family_member1
        (registration_create_params[:primary_family_member_id] &&
          FamilyMember.where(id: registration_create_params[:primary_family_member_id]).first).presence
      end

      def family_member2
        (registration_create_params[:secondary_family_member_id] &&
          FamilyMember.where(id: registration_create_params[:secondary_family_member_id]).first).presence
      end

      def family_member3
        (registration_create_params[:tertiary_family_member_id] &&
          FamilyMember.where(id: registration_create_params[:tertiary_family_member_id]).first).presence
      end

      def registration_create_params
        params.
          require(:registration).
          permit(
            :course_id,
            :primary_family_member_id,
            :secondary_family_member_id,
            :tertiary_family_member_id
          )
      end
    end
  end
end
