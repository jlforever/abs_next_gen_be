class Student < ApplicationRecord
  has_many :family_members
  has_one :parent, through: :family_members

  validates :first_name, :last_name, :date_of_birth, presence: true
end
