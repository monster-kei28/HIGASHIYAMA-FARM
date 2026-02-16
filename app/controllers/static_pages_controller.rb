class StaticPagesController < ApplicationController
  def top
    @events = CalendarEvent.all
  end

  def terms; end
  def privacy; end
  def contact; end
  def guide; end
end
