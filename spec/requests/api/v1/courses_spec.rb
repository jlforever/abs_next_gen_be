require 'rails_helper'

describe Api::V1::CoursesController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:user2) { create(:user, password: 'beiioo12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:parent2) { create(:parent, user: user2) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty_user2) { create(:user, password: 'ckediel12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:faculty2) { create(:faculty, user: faculty_user2) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days, reg_effective_from: Time.zone.now - 3.days, reg_effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now + 1.day, effective_until: Time.zone.now + 10.days, reg_effective_from: Time.zone.now + 1.day, reg_effective_until: Time.zone.now + 10.days) }
  let!(:class3) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 10.days, effective_until: Time.zone.now + 20.days, reg_effective_from: Time.zone.now - 10.days, reg_effective_until: Time.zone.now + 20.days) }
  let!(:class4) { create(:klass, faculty: faculty2, effective_from: Time.zone.now - 10.days, effective_until: Time.zone.now + 20.days, reg_effective_from: Time.zone.now - 10.days, reg_effective_until: Time.zone.now + 20.days) }

  describe 'teaching_sessions' do
    let!(:teaching_session1) { create(:teaching_session, klass: class4, effective_for: Time.zone.now - 8.days) }
    let!(:teaching_session2) { create(:teaching_session, klass: class4, effective_for: Time.zone.now - 9.days) }

    it 'properly retrieves the faculty accessible course\'s teaching sessions' do
      establish_valid_token!(faculty_user2)

      get "/api/v1/courses/#{class4.id}/teaching_sessions", headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      expect(response.status).to eq 200
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['teaching_sessions'].map { |ts| ts['id'] }).to match_array([teaching_session1.id, teaching_session2.id])
    end

    it 'raises exception when a non faculty user is attempting to access' do
      establish_valid_token!(user)
      get "/api/v1/courses/#{class4.id}/teaching_sessions", headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access

      expect(body['errors']['teaching_sessions_retrieval_error']).
        to eq 'Unable to access teaching session as a non faculty user'
    end

    it 'raises exception when a mismatched faculty user is attempting to access an inaccessible course\'s teaching sessions' do
      establish_valid_token!(faculty_user)
      get "/api/v1/courses/#{class4.id}/teaching_sessions", headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access

      expect(body['errors']['teaching_sessions_retrieval_error']).
        to eq 'You\'re unable to access teaching session for a course that you do not have access to'
    end
  end

  describe '.index' do
    context 'when searching without any user' do
      it 'returns all effective courses' do
        get '/api/v1/courses'
        expect(response.status).to eq 200
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:courses].size).to eq 3
        expect(body[:courses].map { |course| course[:id] }).to match_array([class1.id, class3.id, class4.id])
      end
    end

    context 'when searching with a specific user' do
      context 'in faculty perspective' do
        it 'returns faculty manageable classes' do
          establish_valid_token!(faculty_user2)
          get '/api/v1/courses', params: { perspective: 'faculty', user_email: faculty_user2.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }

          expect(response.status).to eq 200
          body = JSON.parse(response.body).with_indifferent_access
          expect(body[:courses].size).to eq 1
          expect(body[:courses].first[:id]).to eq class4.id
        end

        it 'raises unable to find management based course when it is not a faculty user' do
          establish_valid_token!(user2)
          get '/api/v1/courses', params: { perspective: 'faculty', user_email: user2.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
          expect(response.status).to eq 500
          body = JSON.parse(response.body).with_indifferent_access
          expect(body[:errors][:courses_retrieval_error]).
            to eq 'Unable to find management based courses, without a logged in faculty'
        end
      end

      context 'in parent perspective' do
        let!(:student1) { create(:student, first_name: 'Hank', last_name: 'Toms') }
        let!(:student2) { create(:student, first_name: 'Sylvania', last_name: 'Toms') }
        let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
        let!(:registration1) { create(:registration, klass: class1, primary_family_member: family_member1) }
  
        before do
          establish_valid_token!(user)
        end
  
        it 'raises an exception when an authorized user is hitting the endpoint' do
          get '/api/v1/courses', params: { perspective: 'parent', user_email: user2.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
          expect(response.status).to eq 500
          body = JSON.parse(response.body).with_indifferent_access
          expect(body[:errors][:courses_retrieval_error]).
            to eq 'Attempt to retrieve courses, while logged in, via an unauthorized user'
        end
  
        it 'returns un-registered, effective courses' do
          get '/api/v1/courses', params: { perspective: 'parent', user_email: user.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
          expect(response.status).to eq 200
          body = JSON.parse(response.body).with_indifferent_access
          expect(body[:courses].size).to eq 2
          expect(body[:courses].map { |course| course[:id] }).to match_array([class3.id, class4.id])
        end
      end
    end
  end
end
