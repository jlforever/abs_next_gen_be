class KlassVacayDate < ApplicationRecord
  belongs_to :klass
  validates :off_date, presence: true
end
