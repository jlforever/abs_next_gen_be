require 'rails_helper'

describe Api::V1::UserProfileChangesController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let(:base_user_profile_params) do
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
    context 'as a faculty user' do
      let!(:faculty) { create(:faculty, user: user) }
      let(:update_user_profile_params) do
        base_user_profile_params[:profile][:faculty_name] = 'Miss Garrett the Great'
        base_user_profile_params[:profile][:faculty_bio] = 'I am a great teacher, trust me'
 
        base_user_profile_params.merge!({ perspective: 'faculty' })
      end

      it 'properly saves the profile info' do
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

        expect(response.status).to eq 201
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:profile][:first_name]).to eq 'Hank'
        expect(body[:profile][:user_name]).to eq 'Tempt'
        expect(body[:profile][:faculty][:address1]).to eq '305 3rd St'
        expect(body[:profile][:faculty][:zip]).to eq '09165'
        expect(body[:profile][:faculty][:faculty_name]).to eq 'Miss Garrett the Great'
        expect(body[:profile][:faculty][:faculty_bio]).to eq 'I am a great teacher, trust me'
      end
    end

    context 'as a parent user' do
      let!(:parent) { create(:parent, user: user) }
      let(:update_user_profile_params) do
        base_user_profile_params.merge!({ perspective: 'parent' })
      end

      it 'properly saves the profile info' do
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

        expect(response.status).to eq 201
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:profile][:first_name]).to eq 'Hank'
        expect(body[:profile][:user_name]).to eq 'Tempt'
        expect(body[:profile][:parent][:address1]).to eq '305 3rd St'
        expect(body[:profile][:parent][:zip]).to eq '09165'
      end

      it 'enables consecutive updates' do
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

        expect(response.status).to eq 201
        update_user_profile_params[:profile][:phone_number] = '616-116-1169'
        update_user_profile_params[:profile][:emergency_contact] = 'Grant Sonny'
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 201
        update_user_profile_params[:profile][:user_name] = 'Haniti'
        post '/api/v1/user_profile_changes', params: update_user_profile_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 201

        expect(JSON.parse(response.body).with_indifferent_access[:profile][:user_name]).to eq 'Haniti'
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
end
