class Faculty < ApplicationRecord
  belongs_to :user

  validates :user_id, :name, :bio, presence: true
end
