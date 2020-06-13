require 'rails_helper'

describe Api::V1::RegistrationsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:user2) { create(:user, password: 'emmee11133!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:parent2) { create(:parent, user: user2) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now + 3.days, effective_until: Time.zone.now + 10.days) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:student2) { create(:student, first_name: 'Sammy', last_name: 'Duncan') }
  let!(:student3) { create(:student, first_name: 'Marshall', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:family_member2) { create(:family_member, parent: parent2, student: student2) }
  let!(:family_member3) { create(:family_member, parent: parent, student: student3) }
  let(:params) do
    {
      user_email: user.email,
      registration: {
        course_id: class1.id,
        secondary_family_member_id: family_member1
      }
    }
  end

  before do
    establish_valid_token!(user)
  end

  describe '#create' do
    context 'when no first family members is missing' do
      it 'raises an error indicating no primary family member' do
        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        expect(JSON.parse(response.body).with_indifferent_access[:errors][:registration_creation_error]).
          to eq 'You cannot register without a family member'
      end
    end

    context 'when family members do not belong to the same family' do
      it 'raises an error indicating family member do not belong together' do
        params[:registration][:primary_family_member_id] = family_member1.id
        params[:registration][:secondary_family_member_id] = family_member2.id
        params[:registration][:tertiary_family_member_id] = family_member3.id

        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        expect(JSON.parse(response.body).with_indifferent_access[:errors][:registration_creation_error]).
          to eq 'Not all of the specified family members are from the same family'
      end
    end

    context 'when attempt to registered class is not effective' do
      it 'raises a class not found error' do
        params[:registration][:primary_family_member_id] = family_member1.id
        params[:registration][:secondary_family_member_id] = family_member3.id
        params[:registration][:course_id] = class2.id

        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:registration_creation_error]).to match(/Couldn't find Klass/)
      end
    end

    it 'registers a course for a given set of family members' do
      params[:registration][:primary_family_member_id] = family_member1.id
      params[:registration][:secondary_family_member_id] = family_member3.id

      post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 201
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:registration][:klass_id]).to eq params[:registration][:course_id]
      expect(body[:registration][:primary_family_member_id]).to eq family_member1.id
      expect(body[:registration][:secondary_family_member_id]).to eq family_member3.id
      expect(body[:registration][:total_due]).to eq 60000
    end
  end
end
