require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    subject { reservation }

    let(:user) do
      User.create!(
        name: '山田太郎',
        phone_number: '09012345678'
      )
    end

    let(:harvest_experience) do
      HarvestExperience.create!(
        title: 'テスト収穫体験',
      )
    end

    let(:reservation) do
      Reservation.new(
        user: user,
        harvest_experience: harvest_experience,
        number_of_people: 2,
        reserved_at: Time.current
      )
    end

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

    context 'reserved_at' do
      it 'nil の場合は無効' do
        reservation.reserved_at = nil
        expect(reservation).to be_invalid
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