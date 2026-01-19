require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { user }

    let(:user) do
      User.new(
        name: '山田太郎',
        phone_number: '09012345678'
      )
    end

    context '有効な場合' do
      it 'name と phone_number があれば有効' do
        expect(user).to be_valid
      end
    end

    context 'name がない場合' do
      it '無効になる' do
        user.name = nil
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context 'phone_number がない場合' do
      it '無効になる' do
        user.phone_number = nil
        expect(user).to be_invalid
        expect(user.errors[:phone_number]).to include("can't be blank")
      end
    end

    context 'phone_number が重複している場合' do
      it '無効になる' do
        User.create!(
          name: '先に作ったユーザー',
          phone_number: '09012345678'
        )

        expect(user).to be_invalid
        expect(user.errors[:phone_number]).to include('has already been taken')
      end
    end

    context 'phone_number の形式が不正な場合' do
      it 'ハイフンありは無効' do
        user.phone_number = '090-1234-5678'
        expect(user).to be_invalid
      end

      it '桁数が足りない場合は無効' do
        user.phone_number = '0901234'
        expect(user).to be_invalid
      end

      it '桁数が多すぎる場合は無効' do
        user.phone_number = '090123456789'
        expect(user).to be_invalid
      end
    end
  end

  describe 'associations' do
    it 'reservations を複数持つ' do
      association = described_class.reflect_on_association(:reservations)
      expect(association.macro).to eq :has_many
    end

    it 'user が削除されたら reservations も削除される' do
      user = User.create!(
        name: '削除テスト',
        phone_number: '08012345678'
      )

      harvest_experience = HarvestExperience.create!(
        title: 'テスト収穫体験',
      )

      reservation = Reservation.create!(
        user: user,
        harvest_experience: harvest_experience,
        number_of_people: 2,
        reserved_at: Time.current
      )

      expect { user.destroy }.to change { Reservation.count }.by(-1)
    end
  end
end
