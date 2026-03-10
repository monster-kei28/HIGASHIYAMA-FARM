require "csv"

class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :harvest_experience

  attr_accessor :reserved_date, :reserved_time

  before_validation :build_reserved_at_from_virtual_fields

  validates :number_of_people, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reserved_at, presence: true

  validate :reserved_date_must_be_open
  validate :reserved_date_within_range

  def self.to_csv(reservations)
    bom = "\uFEFF"

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["予約ID", "名前", "電話", "体験名", "人数", "予約日時", "作成日時"]

      reservations.each do |reservation|
        csv << [
          reservation.id,
          reservation.user.name,
          reservation.user.phone_number,
          reservation.harvest_experience.title,
          reservation.number_of_people,
          reservation.reserved_at&.strftime("%Y-%m-%d %H:%M"),
          reservation.created_at.strftime("%Y-%m-%d %H:%M:%S")
        ]
      end
    end

    bom + csv_data
  end

  private

  def build_reserved_at_from_virtual_fields
    return if reserved_at.present?
    return if reserved_date.blank? || reserved_time.blank?

    self.reserved_at = Time.zone.parse("#{reserved_date} #{reserved_time}")
  end

  def reserved_date_must_be_open
    return if reserved_at.blank?

    date = reserved_at.to_date
    if CalendarEvent.closed_on?(date)
      errors.add(:reserved_at, "は休業日のため予約できません")
    end
  end

  def reserved_date_within_range
    return if reserved_at.blank?

    date = reserved_at.to_date

    today = Date.current
    now = Time.zone.now

    # 明日の予約締切は今日の17:00
    tomorrow_deadline = Time.zone.local(today.year, today.month, today.day, 17, 0, 0)

    # 17:00を過ぎたら最短予約日は「明後日」
    min =
      if now >= tomorrow_deadline
        today + 2.days
      else
        today + 1.day
      end

    max = today + 60.days

    if date < min || date > max
      errors.add(:reserved_at, "は予約可能な期間外です")
    end
  end
end
