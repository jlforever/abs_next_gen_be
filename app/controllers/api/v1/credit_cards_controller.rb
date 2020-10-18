module Api
  module V1
    class CreditCardsController < ApplicationController
      before_action :authorize_access_request!

      swagger_controller :credit_cards, 'Credit Cards Management'

      swagger_api :index do
        summary 'Returns user associated credit cards'
        param :query, 'user_email', :string, :required, 'querying user\'s email'
        response :unauthorized
        response :internal_server_error
        response :ok
      end

      def index
        begin
          raise 'Unauthorized user access: unable to retrieve credit cards' if unauthorized_access?

          render json: { credit_cards: current_user.credit_cards.map(&:as_serialized_hash) }, status: :ok
        rescue => exception
          render json: { errors: { credit_card_retrieval_error: exception.to_s } }, status: :internal_server_error
        end
      end

      swagger_api :create do
        summary 'Allow user to create a credit card'
        param :form, 'user_email', :string, :required, 'Creator\'s email address'
        param :form, 'credit_card[card_holder_name]', :string, :required, 'Credit card\'s holder name'
        param :form, 'credit_card[card_last_four]', :string, :required, 'Credit card last 4 digits'
        param :form, 'credit_card[card_type]', :string, :required, 'Credit card type (ex: Visa)'
        param :form, 'credit_card[card_expire_month]', :string, :required, 'Credit card expiring month'
        param :form, 'credit_card[card_expire_year]', :string, :required, 'Credit card expiring year'
        param :form, 'credit_card[postal_identification]', :string, :optional, 'Credit card postal code'
        param :form, 'credit_card[stripe_card_token]', :string, :required, 'Client side obtained stripe card token'
      end

      def create
        begin
          raise 'Unauthorized user access: unable to create a credit card' if unauthorized_access?
          
          credit_card = CreditCardCreator.create!(current_user, credit_card_create_params)
          render json: { credit_card: credit_card.as_serialized_hash }, status: :created
        rescue => exception
          render json: { errors: { credit_card_creation_error: exception.to_s } }, status: :internal_server_error
        end
      end

      private

      def unauthorized_access?
        user_email != current_user.email
      end

      def user_email
        @user_email ||= params.require(:user_email)
      end

      def credit_card_create_params
        params.
          require(:credit_card).
          permit(
            :card_holder_name,
            :card_last_four,
            :card_type,
            :card_expire_month,
            :card_expire_year,
            :postal_identification,
            :stripe_card_token
          ) 
      end
    end
  end
end
