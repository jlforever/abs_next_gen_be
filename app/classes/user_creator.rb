class UserCreator
  class CreationError < StandardError; end

  def self.create!(email:, password:)
    new(email: email, password: password).create!
  end

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def create!
    begin
      allocate_new_user.tap do |new_user|
        raise password_invalid_message unless proper_password?

        new_user.password = password
        new_user.save!
        new_user.reload
      end
    rescue => exception
      raise CreationError.new(exception.to_s)
    end
  end

  private

  attr_reader :email, :password

  def allocate_new_user
    User.new(email: email)
  end

  def proper_password?
    [
      /[\w\d\!\@\%]{8,16}/,
      /[\!\@\%\$]+/
    ].all? do |pattern|
      password.match(pattern).present?
    end
  end

  def password_invalid_message
    'password must be between 8 and 16 characters and must contain one of the special characters \'!\', \'@\', \'%\' or \'$\''
  end
end
