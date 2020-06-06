class Specialty < ApplicationRecord
  validates :subject, :category, :focus_areas, presence: true
end
