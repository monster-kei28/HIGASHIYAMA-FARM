# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :harvest_experience

  attr_accessor :reserved_date, :reserved_time

  before_validation :build_reserved_at_from_virtual_fields

  validates :number_of_people, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reserved_at, presence: true

  private

  def build_reserved_at_from_virtual_fields
    return if reserved_at.present?
    return if reserved_date.blank? || reserved_time.blank?

    self.reserved_at = Time.zone.parse("#{reserved_date} #{reserved_time}")
  end
end
