module Api
  module V1
    class RegistrationsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :registrations, 'Registrations Management'

      swagger_api :create do
        summary 'Creating/Registering a class for a set of family members'
        param :header, 'Authorization', :string, :required, 'User procured Acccess Token'
        param :form, 'user_email', :string, :required, 'Parent user email'
        param :form, 'registration[:course_id]', :string, :required, 'Registering class\'s id'
        param :form, 'registration[primary_family_member_id]', :string, :required, 'First registering family member id'
        param :form, 'registration[:secondary_family_member_id]', :string, :optional, 'Second registering family member id'
        param :form, 'registration[:tertiary_family_member_id]', :string, :optional, 'Third registering family member id'
        param :form, 'registration[accept_release_form]', :boolean, :optional, 'Whether the registering parent accepts the video/audio release form'
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
            registration_create_params[:accept_release_form] || false,
            family_member1,
            family_member2,
            family_member3
          )
          render json: { registration: registration.as_serialized_hash }, status: :created
        rescue RegistrationCreator::CreationError => exception
          render json: { errors: { registration_creation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :index do
        summary 'Retrieve user specific owned registrations'
        param :header, 'Authorization', :string, :required, 'User procured Acccess Token'
        param :query, 'user_email', :string, :required, 'Parent user email'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def index
        begin
          raise "Unauthorized access: unable to retrieve registrations with email: #{user_email}" if unauthorized_access?

          registrations = Registration.eligible.of_parent_user(current_user)
          render json: { registrations: registrations.map(&:as_serialized_hash) }, status: :ok
        rescue => exception
          render json: { errors: { registrations_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :class_sessions do
        summary 'Retrieve user registered class\'s sessions'
        param :header, 'Authorization', :string, :required, 'User procured Acccess Token'
        param :query, 'id', :integer, :required, 'Registration\'s unique identifier'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def class_sessions
        begin
          raise "Unauthorized access: unable to retrieve registered class's sessions" if invalid_access_to_registration?
          raise 'Registration passed: unable to get class sessions for a passed registration' if registration.passed?

          class_sessions = registration.class_sessions
          render json: { class_sessions: class_sessions.map(&:as_serialized_hash) }, status: :ok
        rescue => exception
          render json: { errors: { registered_class_session_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :charge_amounts do
        summary 'Calculate to be registered class\'s fees'
        param :form, 'charge_amount_request[:course_id]', :string, :required, 'Registering class\'s id'
        param :form, 'charge_amount_request[primary_family_member_id]', :string, :required, 'First registering family member id'
        param :form, 'charge_amount_request[:secondary_family_member_id]', :string, :optional, 'Second registering family member id'
        param :form, 'charge_amount_request[:tertiary_family_member_id]', :string, :optional, 'Third registering family member id'
        response :unauthorized
        response :internal_server_error
        response :created
      end

      def charge_amounts
        begin
          raise "Unauthorized access: unable to request class's charge amount for incompatible user" if unauthorized_access?
          course = Klass.find(charge_amount_request_params[:course_id])
          amount = CourseFeeCalculator.calculate!(
            course,
            charge_amount_calculation_family_member1,
            charge_amount_calculation_family_member2,
            charge_amount_calculation_family_member3
          )

          render json: { amount: amount }, status: :ok
        rescue => exception
          render json: { charge_amount_calculation_error: exception.to_s }, status: :internal_server_error
        end
      end

      private

      def invalid_access_to_registration?
        registration.primary_family_member.parent.user.email != current_user.email
      end

      def unauthorized_access?
        user_email != current_user.email
      end

      def registration
        @registration ||= Registration.find(params[:id])
      end

      def user_email
        params.require(:user_email)
      end

      def charge_amount_calculation_family_member1
        (charge_amount_request_params[:primary_family_member_id] &&
          FamilyMember.where(id: charge_amount_request_params[:primary_family_member_id]).first).presence
      end

      def charge_amount_calculation_family_member2
        (charge_amount_request_params[:secondary_family_member_id] &&
          FamilyMember.where(id: charge_amount_request_params[:secondary_family_member_id]).first).presence
      end

      def charge_amount_calculation_family_member3
        (charge_amount_request_params[:tertiary_family_member_id] &&
          FamilyMember.where(id: charge_amount_request_params[:tertiary_family_member_id]).first).presence
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
            :tertiary_family_member_id,
            :accept_release_form
          )
      end

      def charge_amount_request_params
        params.
          require(:charge_amount_request).
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
