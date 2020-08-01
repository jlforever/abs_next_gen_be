require 'rails_helper'

describe ClassSessionsMaterialCreator do
  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now + 3.days, effective_until: Time.zone.now + 10.days) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  
  let!(:registration_1) { create(:registration, klass: class1, primary_family_member: family_member1) }
  let!(:class_sessions) do
    registration_1.klass.expected_session_dates.map do |specific_date|
      create(:class_session, registration: registration_1, effective_for: specific_date)
    end
  end

  before do
    allow(S3FileManager).to receive(:upload_object)
    allow(File).to receive(:new).and_return(double('file handle', read: 'some content'))
  end

  it 'uploads the file to s3 and creates a session material envelope' do
    klass = registration_1.klass
    session_effective_date = klass.expected_session_dates.last.strftime('%Y-%m-%d')
    expected_session = class_sessions.detect { |session| session.effective_for == session_effective_date }

    perspective = 'students'
    file_path = '/some_file_path'
    file_name = 'image1.jpg'
    file_type = 'image/jpg'

    expect do
      described_class.create!(
        klass,
        session_effective_date,
        perspective,
        file_name,
        file_path,
        file_type
      )
    end.to change { ClassSessionMaterial.count }.by(1)

    expect(S3FileManager).
      to have_received(:upload_object).
      with(
        klass.materials_holding_folder_name,
        file_name,
        'some content',
        true
      )

    new_session_material = ClassSessionMaterial.last
    expect(new_session_material.class_session).to eq expected_session
    expect(new_session_material.name).to eq file_name
    expect(new_session_material.mime_type).to eq file_type
  end
end
