class StaticPagesController < ApplicationController
  def top
    @events = []  # ← 将来 Event.all に置き換える
  end
end
