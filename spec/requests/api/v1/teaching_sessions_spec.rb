require 'rails_helper'

describe Api::V1::TeachingSessionsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty_user2) { create(:user, password: 'ckediel12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:faculty2) { create(:faculty, user: faculty_user2) }
  let!(:class4) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 10.days, effective_until: Time.zone.now + 20.days, reg_effective_from: Time.zone.now - 10.days, reg_effective_until: Time.zone.now + 20.days) }
  let!(:class5) { create(:klass, faculty: faculty2, effective_from: Time.zone.now - 10.days, effective_until: Time.zone.now + 20.days, reg_effective_from: Time.zone.now - 10.days, reg_effective_until: Time.zone.now + 20.days) }
  let!(:teaching_session1) { create(:teaching_session, klass: class4, effective_for: class4.expected_session_dates[1]) }

  let!(:registration_1) { create(:registration, klass: class4, primary_family_member: family_member1) }
  let!(:registration_1_class_sessions) do
    registration_1.klass.expected_session_dates.map do |specific_date|
      create(:class_session, registration: registration_1, effective_for: specific_date).tap do |class_session|
        if class_session.effective_for.to_date == teaching_session1.effective_for.to_date
          class_session.associate_teaching_session = teaching_session1
          class_session.save
        end
      end
    end
  end

  let(:uploading_material) do
    Rack::Test::UploadedFile.new(
      File.open(File.join(Rails.root, '/spec/fixtures/materials/some-file.pdf')),
      'application/pdf'
    )
  end

  let!(:create_params) do
    {
      student_session_material: uploading_material
    }
  end

  before do
    allow(S3FileManager).to receive(:upload_object)
  end

  describe '.student_materials' do
    it 'encounters non permitted teaching session' do
      establish_valid_token!(faculty_user2)
      post "/api/v1/teaching_sessions/#{teaching_session1.id}/student_materials", params: create_params, headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['errors']['student_session_material_creation_error']).
        to eq 'You\'re not permitted to access this teaching session to perform student uploads'
    end

    it 'properly creates the teaching session student uploads and the class sessions materials' do
      establish_valid_token!(faculty_user)

      expect do
        post "/api/v1/teaching_sessions/#{teaching_session1.id}/student_materials", params: create_params, headers: { 'Authorization' => "Bearer #{@token.access}" }
      end.to change { TeachingSessionStudentUpload.count }.by(1).
        and change { ClassSessionMaterial.count }.by(1)

      expect(response.status).to eq 201

      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:teaching_session_student_upload]).to be_present

      created_teaching_session_student_upload = TeachingSessionStudentUpload.last
      created_class_session_material = ClassSessionMaterial.last
      expect(created_class_session_material.teaching_session_student_upload).
        to eq created_teaching_session_student_upload
      expect(created_class_session_material.class_session.associate_teaching_session).
        to eq teaching_session1
    end
  end
end
