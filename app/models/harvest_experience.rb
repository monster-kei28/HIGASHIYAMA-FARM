class HarvestExperience < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :title, presence: true
end
