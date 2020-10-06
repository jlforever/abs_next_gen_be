class TeachingSessionStudentUploadDestroyer
  def self.destroy!(teaching_session_student_upload)
    new(teaching_session_student_upload).destroy!
  end

  def initialize(teaching_session_student_upload)
    @teaching_session_student_upload = teaching_session_student_upload
  end

  def destroy!
    ActiveRecord::Base.transaction do
      associated_class_session_materials.each(&:destroy)
      teaching_session_student_upload.destroy!

      teaching_session_student_upload
    end
  end

  private

  attr_reader :teaching_session_student_upload

  def associated_class_session_materials
    @associated_class_sessions ||= begin
      teaching_session_student_upload.class_session_materials
    end
  end
end
