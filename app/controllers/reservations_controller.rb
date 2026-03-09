class ReservationsController < ApplicationController
  def new
    selected_date =
      begin
        params[:date].present? ? Date.parse(params[:date]) : nil
      rescue ArgumentError
        nil
      end

    @reservation = Reservation.new(
      reserved_date: selected_date&.to_s
    )

    if selected_date.present?
      flash.now[:notice] = "#{selected_date.strftime('%Y年%m月%d日')}を選択しました。ご希望の時間を選んで予約を完了してください。"
    end

    @harvest_experiences = HarvestExperience.all
    @events = CalendarEvent.all

    range = Date.current..(Date.current + 60.days)
    @closed_dates = CalendarEvent.closed_dates_between(range)

    today = Date.current
    now = Time.zone.now
    deadline = Time.zone.local(today.year, today.month, today.day, 17, 0, 0)

    @min_reservable_date = now >= deadline ? today + 2.days : today + 1.day
    @max_reservable_date = today + 60.days
  end

  def create
    @harvest_experiences = HarvestExperience.all
    @events = CalendarEvent.all

    # ✅ 追加：エラーで render :new したときも必要
    range = Date.current..(Date.current + 60.days)
    @closed_dates = CalendarEvent.closed_dates_between(range)

    today = Date.current
    now = Time.zone.now
    deadline = Time.zone.local(today.year, today.month, today.day, 17, 0, 0)

    @min_reservable_date = now >= deadline ? today + 2.days : today + 1.day
    @max_reservable_date = today + 60.days

    @user =
      if logged_in?
        current_user.tap do |u|
          u.name = params[:reservation][:name]
          u.phone_number = params[:reservation][:phone_number]
        end
      else
        User.find_or_initialize_by(phone_number: params[:reservation][:phone_number]).tap do |u|
          u.name = params[:reservation][:name]
        end
      end

    @reservation = Reservation.new(reservation_params)
    @reservation.user = @user

    if @user.save && @reservation.save
      # ✅ 予約に紐づくユーザーに通知（失敗しても予約は成功）
      if @user.provider == "line" && @user.uid.present?
        begin
          LineMessaging::PushText.call(
            to: @user.uid,
            text: LineMessaging::Messages::ReservationCompleted.build(@reservation)
          )
        rescue => e
          Rails.logger.error("[LINE] push failed user_id=#{@user.id} uid=#{@user.uid} err=#{e.class} #{e.message}")
        end
      end

      redirect_to root_path, notice: "予約が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
  end

  def lookup
    @user = User.find_by(phone_number: params[:phone_number])

    if @user && @user.reservations.any?
      @reservation = @user.reservations.order(created_at: :desc).first
      redirect_to reservation_path(@reservation)
    else
      flash.now[:alert] = "予約が見つかりませんでした"
      @reservation = nil
      render :search, status: :unprocessable_entity
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    user = @reservation.user

    # ✅ 削除前に通知（失敗してもキャンセルは成功）
    if user.provider == "line" && user.uid.present?
      begin
        LineMessaging::PushText.call(
          to: user.uid,
          text: LineMessaging::Messages::ReservationCanceled.build(@reservation)
        )
      rescue => e
        Rails.logger.error("[LINE] cancel push failed user_id=#{user.id} uid=#{user.uid} err=#{e.class} #{e.message}")
      end
    end

    @reservation.destroy
    redirect_to root_path, alert: "予約を取り消しました"
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :harvest_experience_id,
      :number_of_people,
      :reserved_date,
      :reserved_time
    )
  end
end
