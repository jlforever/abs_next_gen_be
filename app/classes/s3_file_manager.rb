class S3FileManager
  def self.url_for_object(object_access_path, object_key)
    new(object_access_path, object_key).url_for_object
  end

  def self.upload_object(object_access_path, object_key, object_body, public_read = false)
    manager = new(object_access_path, object_key, public_read)
    manager.set_uploading_object_body(object_body)
    manager.upload_object
  end

  def self.delete_object(object_access_path, object_key)
    new(object_access_path, object_key).delete_object
  end

  def initialize(object_access_path, object_key, public_read = false)
    @object_access_path = object_access_path
    @object_key = object_key
    @public_read = public_read
  end

  def set_uploading_object_body(object_body)
    @object_body = object_body
  end

  def url_for_object
    resource_access_container.object(object_key).public_url.gsub('%2F', '/')
  end

  def upload_object
    object_wrapper = resource_upload_container.object(File.join(object_access_path, object_key))

    if public_read
      object_wrapper.put(body: object_body, acl: 'public-read')
    else
      object_wrapper.put(body: object_body)
    end
  end

  def delete_object
    object_wrapper = resource_upload_container.object(File.join(object_access_path, object_key))
    object_wrapper.delete
  end

  private

  attr_reader :object_access_path, :object_body, :object_key, :public_read

  def s3_accessor
    Aws::S3::Resource.new(region: configatron.aws.s3_region)
  end

  def resource_access_container
    s3_accessor.bucket(File.join(configatron.aws.s3_bucket, object_access_path))
  end

  def resource_upload_container
    s3_accessor.bucket(configatron.aws.s3_bucket)
  end
end
