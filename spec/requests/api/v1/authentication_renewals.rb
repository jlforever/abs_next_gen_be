require 'rails_helper'

describe Api::V1::AuthenticationRenewalsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:session_establish_time) { Time.zone.local(2020, 5, 10, 10) }

  before do
    @auth_info = establish_session!(user, session_establish_time)
  end

  it 'returns a refreshed session access token when the original one expires' do
    Timecop.freeze(session_establish_time + 2.days) do
      post '/api/v1/authentication_renewals', headers: { 'Authorization' => @auth_info.access }
      
      expect(response.status).to eq 201
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:access]).to be_present
      expect(body[:access]).not_to eq @auth_info.access
      expect(body[:access_expires_at]).to be_present
    end
  end
end
