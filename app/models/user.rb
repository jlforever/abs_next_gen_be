class User < ApplicationRecord
  extend FriendlyId
  include BCrypt

  has_one :parent
  has_one :faculty
  has_many :students, through: :parent
  validates :email, :password_hash, presence: true

  friendly_id :slug_builder, use: [:slugged, :finders, :history], sequence_separator: '-'

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

  def generate_password_reset_token!
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
    end while User.exists?(password_reset_token: self.password_reset_token)

    self.password_reset_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_reset_token!
    self.password_reset_token = nil
    self.password_reset_token_expires_at = nil

    save!
  end

  private

  def slug_builder
    [
      :slugified_user_name,
      :dedup_qualified_slugified_user_name
    ]
  end

  def slugified_user_name
    user_name && user_name.parameterize
  end

  def dedup_qualified_slugified_user_name
    if user_name.present?
      number_of_collided_user_slugs = self.class.where(slug: user_name.parameterize).count

      "#{user_name.parameterize}-#{number_of_collided_user_slugs + 1}"
    end
  end
end
