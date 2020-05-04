class User < ApplicationRecord
  include BCrypt

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(clear_password)
    password == clear_password
  end
end
