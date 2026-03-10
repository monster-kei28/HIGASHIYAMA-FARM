class Admin::ReservationsController < Admin::BaseController
  before_action :set_reservation, only: %i[show destroy]

  def index
    base_query = reservations_query

    @reservations = base_query

    respond_to do |format|
      format.html
      format.csv do
        send_data Reservation.to_csv(base_query),
                  filename: "reservations-#{Time.zone.today}.csv",
                  type: "text/csv; charset=UTF-8"
      end
    end
  end

  def show
  end

  def destroy
    @reservation.destroy
    redirect_to admin_reservations_path, notice: "予約を削除しました"
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservations_query
    Reservation.includes(:user, :harvest_experience)
               .order(reserved_at: :desc)
  end
end
