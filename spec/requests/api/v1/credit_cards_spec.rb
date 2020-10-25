require 'rails_helper'

describe Api::V1::CreditCardsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abeiud12345!') }
  let!(:user2) { create(:user, password: 'bekiet23456!') }

  describe '#index' do
    let!(:card1) do
      create(:credit_card, user: user)
    end

    before do
      establish_valid_token!(user)
    end

    context 'when not able to retrieve credit cards due to wrong user' do
      it 'raises an unauthorized error' do
        get '/api/v1/credit_cards', params: { user_email: user2.email }, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body['errors']['credit_card_retrieval_error']).
          to eq 'Unauthorized user access: unable to retrieve credit cards'
      end
    end

    context 'when eligible to query for associated credit cards' do
      it 'pulls back the user associated credit cards' do
        get '/api/v1/credit_cards', params: { user_email: user.email }, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 200
        body = JSON.parse(response.body).with_indifferent_access
        expect(body['credit_cards'].size).to eq 1
        expect(body['credit_cards'].first['id']).to eq card1.id
      end
    end
  end

  describe '#create' do
    let!(:create_params) do
      {
        user_email: user.email,
        credit_card: {
          card_holder_name: 'Allan Smith',
          card_last_four: '1235',
          card_type: 'Visa',
          card_expire_month: '12',
          card_expire_year: '2023',
          postal_identification: '90550',
          stripe_card_token: 'card_1234aeiou'
        }
      }
    end

    before do
      establish_valid_token!(user)
      allow(Stripe::Customer).
        to receive(:create).
        and_return(double('fake stripe customer', id: 'cust_5678nhjo'))
    end

    context 'when not able to get create credit card due to wrong user' do
      it 'raises an unauthorized error' do
        create_params[:user_email] = user2.email
        post '/api/v1/credit_cards', params: create_params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body['errors']['credit_card_creation_error']).
          to eq 'Unauthorized user access: unable to create a credit card'
      end
    end

    context 'when eligible to create a new user associated credit card' do
      it 'properly creates the credit card for the user' do
        expect do
          post '/api/v1/credit_cards', params: create_params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        end.to change { user.credit_cards.count }.by(1)
        expect(response.status).to eq 201
        body = JSON.parse(response.body).with_indifferent_access
        expect(body['credit_card']['card_holder_name']).to eq 'Allan Smith'
        expect(body['credit_card']['stripe_card_token']).to eq 'card_1234aeiou'
        expect(body['credit_card']['stripe_customer_token']).to eq 'cust_5678nhjo'
      end
    end
  end
end
