class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :harvest_experience

  attr_accessor :reserved_date, :reserved_time

  validates :number_of_people, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reserved_at, presence: true
end
