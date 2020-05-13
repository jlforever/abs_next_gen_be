class Student < ApplicationRecord
  belongs_to :parent

  validates :first_name, :last_name, :date_of_birth, presence: true
end
