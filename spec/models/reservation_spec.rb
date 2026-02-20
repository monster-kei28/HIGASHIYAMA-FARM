require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    subject { reservation }

    let(:reservation) { build(:reservation) }

    context '有効な場合' do
      it 'すべての必須項目があれば有効' do
        expect(reservation).to be_valid
      end
    end

    context 'number_of_people' do
      it 'nil の場合は無効' do
        reservation.number_of_people = nil
        expect(reservation).to be_invalid
      end

      it '0 の場合は無効' do
        reservation.number_of_people = 0
        expect(reservation).to be_invalid
      end

      it '負の数の場合は無効' do
        reservation.number_of_people = -1
        expect(reservation).to be_invalid
      end

      it '整数でない場合は無効' do
        reservation.number_of_people = 1.5
        expect(reservation).to be_invalid
      end
    end

    context "reserved_at" do
      it "reserved_date が nil の場合は無効（reserved_at を生成できない）" do
        reservation.reserved_date = nil
        expect(reservation).to be_invalid
      end

      it "reserved_time が nil の場合は無効（reserved_at を生成できない）" do
        reservation.reserved_time = nil
        expect(reservation).to be_invalid
      end

      it "reserved_date と reserved_time があれば reserved_at が自動で入る" do
        reservation.reserved_at = nil
        reservation.valid?
        expect(reservation.reserved_at).to be_present
      end
    end
  end

  describe 'associations' do
    it 'user に属している' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'harvest_experience に属している' do
      association = described_class.reflect_on_association(:harvest_experience)
      expect(association.macro).to eq :belongs_to
    end
  end
end
