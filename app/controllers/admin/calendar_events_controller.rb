class Admin::CalendarEventsController < Admin::BaseController
  def index
    raw = params[:month].presence || Date.current.to_s
    @month = Date.parse(raw)
    @start_date = @month.beginning_of_month
    @end_date   = @month.end_of_month

    @events_by_date =
      CalendarEvent.where(event_date: @start_date..@end_date).index_by(&:event_date)
  end

  def bulk_update
    month = params[:month].present? ? Date.parse(params[:month]) : Date.current
    start_date = month.beginning_of_month
    end_date   = month.end_of_month

    events_params = params.fetch(:events, {})

    CalendarEvent.transaction do
      # 月内は一旦全消し（未設定も反映したいので）
      CalendarEvent.where(event_date: start_date..end_date).delete_all

      events_params.each do |date_str, kind|
        next if kind.blank?

        date = Date.parse(date_str)

        # 月外（前月/翌月）は無視（month_calendar対策）
        next unless (start_date..end_date).cover?(date)

        # 同じ日付が params 内で重複しても上書きで1件に収束
        CalendarEvent.find_or_initialize_by(event_date: date).tap do |e|
          e.kind = kind
          e.save!
        end
      end
    end

    redirect_to admin_calendar_events_path(month: month.beginning_of_month.strftime("%Y-%m-%d")),
                notice: "月のカレンダー設定を保存しました"
  rescue ArgumentError
    redirect_to admin_calendar_events_path, alert: "日付の形式が不正です"
  end
end
