class Parent < ApplicationRecord
  belongs_to :user
  has_many :students

  validates :user_id, presence: true, uniqueness: true
end
