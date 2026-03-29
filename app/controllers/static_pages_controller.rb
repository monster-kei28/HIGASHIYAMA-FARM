class StaticPagesController < ApplicationController
  def top
    @events = CalendarEvent.all

    today = Date.current
    now = Time.zone.now
    deadline = Time.zone.local(today.year, today.month, today.day, 17, 0, 0)

    @min_reservable_date = now >= deadline ? today + 2.days : today + 1.day
    @max_reservable_date = today + 60.days

    @calendar_closed_dates = CalendarEvent.where(kind: :closed).pluck(:event_date)
  end

  def terms; end
  def privacy; end
  def contact; end
  def guide; end
end
