class CalendarEvent < ApplicationRecord
  enum :kind, { open: 0, closed: 1 }

  validates :event_date, presence: true
  validates :kind, presence: true

  def start_time
    event_date.to_time
  end

  def title
    open? ? "開催" : "休み"
  end

  # ✅ 追加：休み判定
  def self.closed_on?(date)
    where(event_date: date, kind: :closed).exists?
  end

  # ✅ 追加：休み日一覧（配列で返す）
  def self.closed_dates_between(range)
    from = range.begin.to_date.beginning_of_day
    to   = range.end.to_date.end_of_day

    where(event_date: from..to, kind: :closed)
      .pluck(:event_date)
      .map { |dt| dt.to_date.to_s }   # ✅ "YYYY-MM-DD" に揃える
      .uniq
  end
end
