class Faculty < ApplicationRecord
  belongs_to :user

  validates :user_id, :bio, presence: true
end
