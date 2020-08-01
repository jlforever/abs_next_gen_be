class ClassSessionsMaterialCreator
  def self.create!(klass, session_effective_date, perspective, file_name, file_path, file_type)
    new(klass, session_effective_date, perspective, file_name, file_path, file_type).create!
  end

  def initialize(klass, session_effective_date, perspective, file_name, file_path, file_type)
    @klass = klass
    @session_effective_date = session_effective_date
    @perspective = perspective
    @file_name = file_name
    @file_path = file_path
    @file_type = file_type
  end

  def create!
    upload_file_to_s3!

    ActiveRecord::Base.transaction do
      pertinent_class_sessions.each do |session|
        session.materials.create!(
          name: file_name,
          audience: perspective,
          mime_type: file_type
        )
      end
    end
  end

  private

  attr_reader :klass, :session_effective_date, :perspective, :file_name, :file_path, :file_type

  def pertinent_class_sessions
    @pertinent_class_sessions ||= begin
      klass.registrations.map(&:class_sessions).flatten.find_all do |class_session|
        class_session.effective_for == session_effective_date
      end
    end
  end

  def upload_file_to_s3!
    S3FileManager.upload_object(
      folder_path,
      file_name,
      File.new(File.join(file_path, file_name)).read,
      true
    )
  end

  def folder_path
    @folder_path ||= klass.materials_holding_folder_name
  end
end
