require "rails_helper"

RSpec.describe "Reservations", type: :request do
  describe "GET /reservations/new" do
    it "新規予約画面が表示される" do
      get new_reservation_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /reservations" do
    context "パラメータが正しい場合" do
      it "予約が1件作成される" do
        harvest_experience = create(:harvest_experience)

        expect {
          post reservations_path, params: {
            reservation: {
              name: "山田太郎",
              phone_number: "09012345678",
              harvest_experience_id: harvest_experience.id,
              number_of_people: 2,
              reserved_date: Date.current,
              reserved_time: "10:00"
            }
          }
        }.to change(Reservation, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq "予約が完了しました"
      end
    end

    context "パラメータが不正な場合" do
      it "予約が作成されず、new が再表示される" do
        harvest_experience = create(:harvest_experience)

        expect {
          post reservations_path, params: {
            reservation: {
              name: "山田太郎",
              phone_number: "09012345678",
              harvest_experience_id: harvest_experience.id,
              number_of_people: nil, # バリデーション違反
              reserved_date: Date.current,
              reserved_time: "10:00"
            }
          }
        }.not_to change(Reservation, :count)

        expect(response).to have_http_status(422)
      end

      context "同じ電話番号のユーザーが既に存在する場合" do
        it "User は増えず、Reservation だけが作成される" do
          harvest_experience = create(:harvest_experience)
          user = create(:user, phone_number: "09099998888")

          expect {
            post reservations_path, params: {
              reservation: {
                name: "別の名前で上書き",
                phone_number: user.phone_number,
                harvest_experience_id: harvest_experience.id,
                number_of_people: 3,
                reserved_date: Date.current,
                reserved_time: "10:00"
              }
            }
          }.to change(User, :count).by(0)
           .and change(Reservation, :count).by(1)

          reservation = Reservation.last
          expect(reservation.user).to eq user
          expect(user.reload.name).to eq "別の名前で上書き"

          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq "予約が完了しました"
        end
      end
    end
  end

  describe "GET /reservations/search" do
    it "予約検索画面が表示される" do
      get search_reservations_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /reservations/lookup" do
    context "該当する予約が存在する場合" do
      it "予約詳細画面にリダイレクトされる" do
        reservation = create(:reservation)

        post lookup_reservations_path, params: {
          phone_number: reservation.user.phone_number
        }

        expect(response).to redirect_to(reservation_path(reservation))
      end
    end

    context "該当する予約が存在しない場合" do
      it "search が再表示される" do
        post lookup_reservations_path, params: {
          phone_number: "09000000000"
        }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "GET /reservations/:id" do
    it "予約詳細が表示される" do
      reservation = create(:reservation)

      get reservation_path(reservation)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /reservations/:id" do
    it "予約が削除される" do
      reservation = create(:reservation)

      expect {
        delete reservation_path(reservation)
      }.to change(Reservation, :count).by(-1)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq "予約を取り消しました"
    end
  end
end
