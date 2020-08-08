require 'rails_helper'

describe Api::V1::ClassSessionsController do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:user2) { create(:user, password: 'emmee11133!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:parent2) { create(:parent, user: user2) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:student2) { create(:student, first_name: 'Sammy', last_name: 'Duncan') }
  let!(:family_member2) { create(:family_member, parent: parent2, student: student2) }
  let!(:registration_1) { create(:registration, klass: class1, primary_family_member: family_member1) }
  let!(:registration_1_class_sessions) do
    registration_1.klass.expected_session_dates.map do |specific_date|
      create(:class_session, registration: registration_1, effective_for: specific_date)
    end
  end
  let!(:registration_2) { create(:registration, klass: class1, primary_family_member: family_member2) }
  let!(:registration_2_class_sessions) do
    registration_2.klass.expected_session_dates.map do |specific_date|
      create(:class_session, registration: registration_2, effective_for: specific_date)
    end
  end

  before do
    establish_valid_token!(user)

    allow(S3FileManager).to receive(:upload_object)
    allow(File).to receive(:new).and_return(double('file handle', read: 'some content'))

    klass = registration_1.klass
    session_effective_date = klass.expected_session_dates.last.strftime('%Y-%m-%d')
    expected_session = registration_1_class_sessions.detect { |session| session.effective_for == session_effective_date }

    perspective = 'students'
    file_path = '/some_file_path'
    file_name = 'image1.jpg'
    file_type = 'image/jpg'

    ClassSessionsMaterialCreator.create!(
      klass,
      session_effective_date,
      perspective,
      file_name,
      file_path,
      file_type
    )

    allow_any_instance_of(ClassSessionMaterial).to receive(:material_access_url).and_return('http://s3.aws/example-material')
  end

  describe '#show' do
    it 'raises unauthorized error when class session is not accessible by the logged in user' do
      get "/api/v1/class_sessions/#{registration_2_class_sessions.last.id}", headers: { 'Authorization' => "Bearer #{@token.access}" }
      
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['errors']['class_session_retrieval_error']).
        to match /Unable to retrieve the specific class session, you do not have access to it/
    end

    it 'retrieves the' do
      get "/api/v1/class_sessions/#{registration_1_class_sessions.last.id}", headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 200

      body = JSON.parse(response.body).with_indifferent_access
      expect(body['class_session']['student_materials'].size).to eq 1
      expect(body['class_session']['student_materials'].first['mime_type']).to eq 'image/jpg'
      expect(body['class_session']['student_materials'].first['name']).to eq 'image1.jpg'
      expect(body['class_session']['student_materials'].first['material_access_url']).to eq 'http://s3.aws/example-material'
    end
  end
end
