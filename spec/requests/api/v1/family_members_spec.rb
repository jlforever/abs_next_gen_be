require 'rails_helper'

describe Api::V1::FamilyMembersController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:student) { create(:student, first_name: 'Helen', last_name: 'Downty') }

  before do
    establish_valid_token!(user)
  end

  describe '#create' do
    let(:family_member_create_params) do
      {
        student: {
          first_name: 'Helen',
          last_name: 'Downty',
          nickname: 'hd',
          date_of_birth: '2015-3-12'
        }
      }
    end

    it 'properly creates a family member for the given parent and student' do
      post '/api/v1/family_members', params: family_member_create_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      expect(response.status).to eq 201
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:family_member][:parent_id]).to eq parent.id
      expect(body[:family_member][:student][:first_name]).to eq family_member_create_params[:student][:first_name]
      expected_age = ((Time.zone.now - Time.zone.parse('2015-3-12')) / 1.year).floor
      expect(body[:family_member][:student][:age]).to eq expected_age
    end
  
    it 'encounters family member already exists error' do
      create(:family_member, parent: parent, student: student)
      post '/api/v1/family_members', params: family_member_create_params, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:errors][:family_member_creation_error]).
        to eq 'The specified student with name: Helen Downty has already been added'
    end
  end

  describe '#index' do
    let!(:new_family_member) { create(:family_member, parent: parent, student: student) }
  
    it 'encounters unauthorized user error' do
      get '/api/v1/family_members', params: { user_email: 'wrongemail@example.com' }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:errors][:family_member_retrieval_errors]).
        to eq 'Attempt to retrieve family members with an unauthorized user'
    end

    it 'retrieves the family members of the parent user' do
      get '/api/v1/family_members', params: { user_email: parent.user.email }, headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      expect(response.status).to eq 200
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:family_members].size).to eq 1
      expect(body[:family_members].first[:parent_id]).to eq parent.id
      expect(body[:family_members].first[:student][:first_name]).to eq student.first_name
      expect(body[:family_members].first[:student][:last_name]).to eq student.last_name
    end
  end

  describe '#destroy' do
    let!(:new_family_member) { create(:family_member, parent: parent, student: student) }
    let!(:another_user) { create(:user, password: 'eee244!') }
    let!(:another_parent) { create(:parent, user: another_user) }
    let(:another_family_member) { create(:family_member, parent: another_parent) }

    it 'encounters unauthorized user error' do
      delete "/api/v1/family_members/#{another_family_member.id}", headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:errors][:family_member_deletion_error]).
        to eq 'Attempt to delete a family member with an unauthorized user'
    end

    it 'successfully deletes a family member' do
      expect do
        delete "/api/v1/family_members/#{new_family_member.id}", headers: { JWTSessions.access_header => "Bearer #{@token.access}" }
      end.to change { parent.family_members.count }.by(-1)
      expect(response.status).to eq 200
    end
  end
end
