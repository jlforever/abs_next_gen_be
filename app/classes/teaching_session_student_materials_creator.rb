class TeachingSessionStudentMaterialsCreator
  def self.create!(teaching_session, material, file_name, file_type)
    new(teaching_session, material, file_name, file_type).create!
  end

  def initialize(teaching_session, material, file_name, file_type)
    @teaching_session = teaching_session
    @material = material
    @file_name = file_name
    @file_type = file_type
  end

  def create!
    upload_file_to_s3!

    ActiveRecord::Base.transaction do
      created_upload = create_teaching_session_student_upload!

      pertinent_class_sessions.each do |session|
        new_material = session.materials.create!(
          name: file_name,
          audience: 'students',
          mime_type: file_type,
          teaching_session_student_upload: created_upload
        )
      end

      created_upload
    end
  end

  private

  attr_reader :teaching_session, :material, :file_name, :file_type

  def klass
    @klass ||= teaching_session.klass 
  end

  def pertinent_class_sessions
    @pertinent_class_sessions ||= begin
      teaching_session.associate_class_sessions.find_all do |class_session|
        class_session.effective_for.to_date == effective_for_date
      end
    end
  end

  def effective_for_date
    @effective_for_date ||= teaching_session.effective_for.to_date 
  end

  def create_teaching_session_student_upload!
    TeachingSessionStudentUpload.create!(
      teaching_session: teaching_session,
      name: file_name,
      mime_type: file_type
    )
  end

  def upload_file_to_s3!
    S3FileManager.upload_object(
      folder_path,
      file_name,
      material.read,
      true
    )
  end

  def folder_path
    @folder_path ||= klass.materials_holding_folder_name
  end
end
