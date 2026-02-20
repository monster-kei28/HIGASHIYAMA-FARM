class CalendarEvent < ApplicationRecord
end
class CalendarEvent < ApplicationRecord
  enum :kind, { open: 0, closed: 1 }

  validates :event_date, presence: true
  validates :kind, presence: true

  # simple_calendar が event.start_time を見に行くため
  def start_time
    event_date.to_time
  end

  # あなたのカレンダー view が event.title を表示するため
  def title
    open? ? "開催" : "休み"
  end
end
