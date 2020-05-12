require 'rails_helper'

describe Api::V1::UserProfileChangesController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:session_establish_time) { Time.zone.local(2020, 5, 10, 10) }
  let!(:parent) { create(:parent, user: user) }
  let(:update_user_profile_params) do
    {
      profile: {
        first_name: 'Hank',
        last_name: 'Sonny',
        user_name: 'Tempt',
        phone_number: '616-116-1166',
        emergency_contact: 'Tania Sonny',
        emergency_contact_phone_number: '616-233-0033',
        timezone: 'America/New_York',
        address1: '305 3rd St',
        address2: 'Apt E',
        city: 'Salem',
        state: 'VT',
        zip: '09165'
      }
    }
  end

  before do
    establish_valid_token!(user)
  end

  describe '#create' do
    it 'properly saves the profile info' do
      post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

      expect(response.status).to eq 201
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:profile][:first_name]).to eq 'Hank'
      expect(body[:profile][:user_name]).to eq 'Tempt'
      expect(body[:profile][:parent][:address1]).to eq '305 3rd St'
      expect(body[:profile][:parent][:zip]).to eq '09165'
    end
  
    context 'with data malformed or incomplete issues' do
      it 'encounters an user name already taken error' do
        create(:user, password: 'aaaeee11122$', user_name: 'Tempt')

        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:profile_mutation_error]).
          to match /The user name Tempt has already been taken/
      end

      it 'encounters the missing name error' do
        update_user_profile_params[:profile][:first_name] = nil
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:profile_mutation_error]).
          to match /You must provide your first and last name/
      end

      it 'encounters phone number not available error' do
        update_user_profile_params[:profile][:phone_number] = nil
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:profile_mutation_error]).
          to match /You must provide your phone number/
      end

      it 'encounters address not complete error' do
        update_user_profile_params[:profile][:city] = nil
        update_user_profile_params[:profile][:zip] = nil
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:profile_mutation_error]).
          to match /You must provide your address/
      end
    end
  end
end
