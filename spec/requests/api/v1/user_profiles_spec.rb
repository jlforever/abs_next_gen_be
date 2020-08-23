require 'rails_helper'

describe Api::V1::UserProfilesController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'aeiiee12345!') }
  let!(:parent) { create(:parent, user: user) }

  let(:profile_populate_data) do
    {
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
  end

  before do
    establish_valid_token!(user)
    ParentUserProfileUpdater.update!(user: user, profile_params: profile_populate_data)
  end

  it 'encounters forbidden access error' do
    get '/api/v1/user_profiles', params: { email: 'someone@aeiou.edu' }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
    expect(response.status).to eq 403
    body = JSON.parse(response.body).with_indifferent_access

    expect(body[:errors][:forbidden_to_retrieve_profile_error]).
      to eq 'You\'re forbidden to access this user profile'
  end

  it 'retrieves back the user\'s associated profile info' do
    get '/api/v1/user_profiles', params: { email: user.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
    expect(response.status).to eq 200
    body = JSON.parse(response.body).with_indifferent_access

    expect(body[:profile][:email]).to eq user.email
    expect(body[:profile][:first_name]).to eq 'Hank'
    expect(body[:profile][:slug]).to eq 'tempt'
    expect(body[:profile][:parent][:address2]).to eq 'Apt E'
    expect(body[:profile][:parent][:zip]).to eq '09165'
  end
end
