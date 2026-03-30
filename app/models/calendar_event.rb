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

  # バリデーション用：指定日が休業日か判定する
  def self.closed_on?(date)
    where(event_date: date.to_date, kind: :closed).exists?
  end

  # カレンダー表示用：休業日一覧を返す
  def self.closed_dates
    where(kind: :closed).pluck(:event_date)
  end

  # フォーム判定用：指定範囲内の休業日一覧を返す
  def self.closed_dates_between(range)
    from = range.begin.to_date.beginning_of_day
    to   = range.end.to_date.end_of_day

    where(event_date: from..to, kind: :closed)
      .pluck(:event_date)
      .map(&:to_date)   # ✅ "YYYY-MM-DD" に揃える
      .uniq
  end
end
