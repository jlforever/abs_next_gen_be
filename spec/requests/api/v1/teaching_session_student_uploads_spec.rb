require 'rails_helper'

describe Api::V1::TeachingSessionsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:faculty_user2) { create(:user, password: 'ckediel12345!') }
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

  let!(:teaching_session2) { create(:teaching_session, klass: class4, effective_for: class5.expected_session_dates[1]) }
  let!(:student_upload_for_teaching_session2) { create(:teaching_session_student_upload, teaching_session: teaching_session2, name: 'another-file.pdf') }

  before do
    allow(S3FileManager).to receive(:upload_object)
    allow(S3FileManager).to receive(:url_for_object)
    @upload = TeachingSessionStudentMaterialsCreator.create!(
      teaching_session1,
      File.open(File.join(Rails.root, '/spec/fixtures/materials/some-file.pdf')),
      'some-file.pdf',
      'application/pdf'
    )
  end

  describe '#destroy' do
    it 'raises error when teaching session is not accessible' do
      establish_valid_token!(faculty_user2)

      delete "/api/v1/teaching_sessions/#{teaching_session1.id}/student_materials/#{@upload.id}", headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:errors][:delete_teaching_session_student_upload_error]).
        to match /not permitted to access this teaching session/
    end

    it 'raises teaching session and student upload mismatched error' do
      establish_valid_token!(faculty_user)
      delete "/api/v1/teaching_sessions/#{teaching_session1.id}/student_materials/#{student_upload_for_teaching_session2.id}", headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:errors][:delete_teaching_session_student_upload_error]).
        to match /to be deleted student upload and the accessing teaching session are mismatched/
    end

    it 'properly deletes the teaching session student upload, as well as the associated class session materials' do
      establish_valid_token!(faculty_user)

      expect do
        delete "/api/v1/teaching_sessions/#{teaching_session1.id}/student_materials/#{@upload.id}", headers: { 'Authorization' => "Bearer #{@token.access}" }
      end.to change { ClassSessionMaterial.count }.by(-1).
        and change { TeachingSessionStudentUpload.count }.by(-1)

      expect(response.status).to eq 200
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:teaching_session_student_upload][:id]).to eq @upload.id
    end
  end
end
