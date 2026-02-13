class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
    @harvest_experiences = HarvestExperience.all
  end

  def create
    @harvest_experiences = HarvestExperience.all

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
      # ✅ LINEログインユーザーだけ通知（失敗しても予約は成功）
      if logged_in? && current_user.provider == "line" && current_user.uid.present?
        begin
          LineMessaging::PushText.call(
            to: current_user.uid,
            text: "予約が完了しました。\n日時: #{@reservation.reserved_at}\n人数: #{@reservation.number_of_people}名"
          )
        rescue => e
          Rails.logger.error("[LINE] push failed user_id=#{current_user.id} uid=#{current_user.uid} err=#{e.class} #{e.message}")
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
    @reservation.destroy
    redirect_to root_path, alert: "予約を取り消しました"
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :harvest_experience_id,
      :number_of_people,
      :reserved_at
    )
  end
end
