require 'rails_helper'

describe Api::V1::FamilyMembersController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:student) { create(:student, first_name: 'Helen', last_name: 'Downty') }

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

  before do
    establish_valid_token!(user)
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
