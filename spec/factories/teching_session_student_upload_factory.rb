FactoryBot.define do
  factory :teaching_session_student_upload do
    teaching_session
    name { 'some-file.pdf' }
    mime_type { 'application/pdf' }
  end
end
