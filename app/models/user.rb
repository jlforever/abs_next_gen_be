class User < ApplicationRecord
  extend FriendlyId
  include BCrypt

  has_one :parent
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
