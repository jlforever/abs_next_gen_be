require 'rails_helper'

describe Api::V1::CoursesController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:user2) { create(:user, password: 'beiioo12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days, reg_effective_from: Time.zone.now - 3.days, reg_effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now + 1.day, effective_until: Time.zone.now + 10.days, reg_effective_from: Time.zone.now + 1.day, reg_effective_until: Time.zone.now + 10.days) }
  let!(:class3) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 10.days, effective_until: Time.zone.now + 20.days, reg_effective_from: Time.zone.now - 10.days, reg_effective_until: Time.zone.now + 20.days) }

  describe '.index' do
    context 'when searching without any user' do
      it 'returns all effective courses' do
        get '/api/v1/courses'
        expect(response.status).to eq 200
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:courses].size).to eq 2
        expect(body[:courses].map { |course| course[:id] }).to match_array([class1.id, class3.id])
      end
    end

    context 'when searching with a specific user' do
      let!(:student1) { create(:student, first_name: 'Hank', last_name: 'Toms') }
      let!(:student2) { create(:student, first_name: 'Sylvania', last_name: 'Toms') }
      let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
      let!(:registration1) { create(:registration, klass: class1, primary_family_member: family_member1) }

      before do
        establish_valid_token!(user)
      end

      it 'raises an exception when an authorized user is hitting the endpoint' do
        get '/api/v1/courses', params: { user_email: user2.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:courses_retrieval_error]).
          to eq 'Attempt to retrieve courses, while logged in, via an unauthorized user'
      end

      it 'returns un-registered, effective courses' do
        get '/api/v1/courses', params: { user_email: user.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
        expect(response.status).to eq 200
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:courses].size).to eq 1
        expect(body[:courses].first[:id]).to eq class3.id
      end
    end
  end
end
