require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    context "作成時（LINEログイン直後など）" do
      it "provider と uid があれば、name/phone_number が未入力でも有効（update時に必須にする設計）" do
        user = build(:user, :line_login)
        expect(user).to be_valid
      end
    end

    context "更新時（予約時）" do
      let(:user) { create(:user, :line_login) }

      it "name と phone_number があれば有効" do
        user.name = "山田太郎"
        user.phone_number = "09012340009"
        expect(user).to be_valid(:update)
      end

      it "name がない場合は無効" do
        user.name = nil
        user.phone_number = "09012340009"

        expect(user).to be_invalid(:update)
        expect(user.errors[:name]).to include("can't be blank")
      end

      it "phone_number がない場合は無効" do
        user.name = "山田太郎"
        user.phone_number = nil

        expect(user).to be_invalid(:update)
        expect(user.errors[:phone_number]).to include("can't be blank")
      end

      it "phone_number が重複している場合は無効" do
        create(:user, name: "既存ユーザー", phone_number: "09012340011")

        user.name = "山田太郎"
        user.phone_number = "09012340011"

        expect(user).to be_invalid(:update)
        expect(user.errors[:phone_number]).to include("has already been taken")
      end

      it "phone_number にハイフンが含まれる場合は無効" do
        user.name = "山田太郎"
        user.phone_number = "090-1234-5678"
        expect(user).to be_invalid(:update)
      end

      it "phone_number の桁数が足りない場合は無効" do
        user.name = "山田太郎"
        user.phone_number = "0901234"
        expect(user).to be_invalid(:update)
      end

      it "phone_number の桁数が多すぎる場合は無効" do
        user.name = "山田太郎"
        user.phone_number = "090123456789"
        expect(user).to be_invalid(:update)
      end
    end
  end

  describe "associations" do
    it "reservations を複数持つ" do
      association = described_class.reflect_on_association(:reservations)
      expect(association.macro).to eq :has_many
    end

    it "user が削除されたら reservations も削除される" do
      user = create(:user, name: "山田太郎", phone_number: "09012345678")
      create(:reservation, user: user)

      expect { user.destroy }.to change { Reservation.count }.by(-1)
    end
  end
end
