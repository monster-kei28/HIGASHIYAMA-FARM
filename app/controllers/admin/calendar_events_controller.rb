class Admin::CalendarEventsController < Admin::BaseController
  def index
    @month = params[:month].present? ? Date.parse(params[:month]) : Date.current
    @start_date = @month.beginning_of_month
    @end_date   = @month.end_of_month

    @events_by_date =
      CalendarEvent.where(event_date: @start_date..@end_date).index_by(&:event_date)
  end

  def bulk_update
    month = params[:month].present? ? Date.parse(params[:month]) : Date.current
    start_date = month.beginning_of_month
    end_date   = month.end_of_month

    events_params = params.fetch(:events, {}) # {"YYYY-MM-DD"=>"open/closed/''"}

    CalendarEvent.transaction do
      # ✅ その月は丸ごと置き換え（正確・シンプル）
      CalendarEvent.where(event_date: start_date..end_date).delete_all

      events_params.each do |date_str, kind|
        next if kind.blank?
        CalendarEvent.create!(event_date: Date.parse(date_str), kind: kind)
      end
    end

    redirect_to admin_calendar_events_path(month: month.strftime("%Y-%m-01")),
                notice: "月のカレンダー設定を保存しました"
  rescue ArgumentError
    redirect_to admin_calendar_events_path, alert: "日付の形式が不正です"
  end
end