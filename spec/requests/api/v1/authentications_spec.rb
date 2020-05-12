require 'rails_helper'

describe Api::V1::AuthenticationsController, type: :request do
  let!(:user) { create(:user, password: 'abcde12345!') }

  it 'properly handles the authentication of a valid user email and password' do
    post '/api/v1/authentications', params: { user: { email: user.email, password: 'abcde12345!' } }
    expect(response.status).to eq 201
    body = JSON.parse(response.body).with_indifferent_access

    expect(body).to have_key(:access)
    expect(body).to have_key(:access_expires_at)
  end

  it 'raises 401 unauthorized for an invalid password' do
    post '/api/v1/authentications', params: { user: { email: user.email, password: 'defg12345!' } }
    expect(response.status).to eq 401
  end
end
