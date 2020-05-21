class Parent < ApplicationRecord
  belongs_to :user
  has_many :family_members
  has_many :students, through: :family_members

  validates :user_id, presence: true, uniqueness: true
end
