class StaticPagesController < ApplicationController
  def top
    @events = []  # ← 将来 Event.all に置き換える
  end
  def terms; end
  def privacy; end
  def contact; end
end
