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
