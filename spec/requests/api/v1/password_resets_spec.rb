require 'rails_helper'

describe Api::V1::PasswordResetsController, type: :request do
  let(:user) { create(:user, password: 'abcde12345!') }

  before do
    user.generate_password_reset_token!
  end

  describe '#edit' do
    it 'raises an exception when an invalid, unrecognized reset token' do
      token = user.password_reset_token + '-007'
      get "/api/v1/password_resets/#{token}/edit"
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['errors']['password_reset_token_invalid_error']).
        to eq 'Unable to find a user with the specified reset token'
    end

    it 'raises an exception when a reset token has expired' do
      user.update!(password_reset_token_expires_at: 2.days.ago)
      get "/api/v1/password_resets/#{user.password_reset_token}/edit"
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['errors']['password_reset_token_invalid_error']).
        to eq 'Specified reset token has expired'
    end

    it 'successfully verifies the password token, with a 200 response status' do
      get "/api/v1/password_resets/#{user.password_reset_token}/edit"
      expect(response.status).to eq 200
    end
  end

  describe '#update' do
    it 'raises password and password confirmation mis-matched exception' do
      put "/api/v1/password_resets/#{user.password_reset_token}", params: { password_reset: { password: 'abcde67890!', password_confirmation: 'abcde67891!' } }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['errors']['password_update_error']).
        to eq 'Password and password confirmation are not matching, please try again'
    end

    it 'successfully updates the user password and clears the reset token and flushes the previus user session' do
      identified_session = double('session', flush_namespaced: nil)
      allow(JWTSessions::Session).to receive(:new).and_return(identified_session)
      put "/api/v1/password_resets/#{user.password_reset_token}", params: { password_reset: { password: 'abcde67890!', password_confirmation: 'abcde67890!' } }
      expect(response.status).to eq 200
      reloaded_user = User.find(user.id)

      expect(JWTSessions::Session).to have_received(:new).with({ namespace: "user_id_#{user.id}" })
      expect(identified_session).to have_received(:flush_namespaced)
      result = (reloaded_user.password == 'abcde67890!')
      expect(result).to be_truthy
      expect(reloaded_user.password_reset_token).to be_nil
      expect(reloaded_user.password_reset_token_expires_at).to be_nil
    end
  end
end
