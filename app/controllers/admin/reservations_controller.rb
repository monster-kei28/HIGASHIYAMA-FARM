class Admin::ReservationsController < Admin::BaseController
  def index
    @reservations = Reservation.includes(:user, :harvest_experience)
                              .order(reserved_at: :desc)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def destroy
    reservation = Reservation.find(params[:id])
    reservation.destroy
    redirect_to admin_reservations_path, notice: "予約を削除しました"
  end
end
