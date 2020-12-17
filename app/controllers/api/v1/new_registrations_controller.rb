module Api
  module V1
    class NewRegistrationsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :registrations, 'New Registrations Management'

      swagger_api :create do
        summary 'Creating/Registering a class for a set of family members'
        param :header, 'Authorization', :string, :required, 'User procured Acccess Token'
        param :form, 'user_email', :string, :required, 'Parent user email'
        param :form, 'registration[:credit_card_id]', :integer, :optional, 'Registrating user\'s credit card identifier'
        param :form, 'registration[:charge_amount]', :integer, :required, 'Registertion\'s charging amount'
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

          ActiveRecord::Base.transaction do
            registration = RegistrationCreator.create!(
              current_user,
              registration_create_params[:course_id],
              registration_create_params[:accept_release_form] || false,
              family_member1,
              family_member2,
              family_member3,
              registration_create_params[:charge_amount]
            )

            unless pay_later?
              RegistrationChargeCapturer.capture!(
                registration,
                registration_create_params[:charge_amount],
                credit_card
              )
            end

            PostRegistrationNotifier.notify(registration.reload)
            render json: { registration: registration.as_serialized_hash }, status: :created
          end
        rescue RegistrationCreator::CreationError, RegistrationChargeCapturer::CaptureError => exception
          render json: { errors: { registration_creation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def pay_later?
        registration_create_params[:credit_card_id].blank? 
      end

      def user_email
        params.require(:user_email)
      end

      def unauthorized_access?
        user_email != current_user.email
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

      def credit_card
        @credit_card ||= current_user.credit_cards.find(registration_create_params[:credit_card_id]) 
      end

      def registration_create_params
        params.
          require(:registration).
          permit(
            :course_id,
            :credit_card_id,
            :charge_amount,
            :primary_family_member_id,
            :secondary_family_member_id,
            :tertiary_family_member_id,
            :accept_release_form
          )
      end
    end
  end
end
