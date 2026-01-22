require 'rails_helper'

RSpec.describe HarvestExperience, type: :model do
  describe 'validations' do
    context '有効な場合' do
      it 'title があれば有効である' do
        harvest_experience = HarvestExperience.new(title: 'テスト収穫体験')
        expect(harvest_experience).to be_valid
      end
    end

    context '無効な場合' do
      it 'title がない場合は無効である' do
        harvest_experience = HarvestExperience.new(title: nil)
        expect(harvest_experience).to be_invalid
        expect(harvest_experience.errors[:title]).to include("can't be blank")
      end
    end
  end

  describe 'associations' do
    it 'reservations を複数持つ' do
      association = described_class.reflect_on_association(:reservations)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'dependent destroy' do
    it 'harvest_experience が削除されたら reservations も削除される' do
      user = User.create!(
        name: '山田太郎',
        phone_number: '09012345678'
      )

      harvest_experience = HarvestExperience.create!(
        title: 'テスト収穫体験'
      )

      Reservation.create!(
        user: user,
        harvest_experience: harvest_experience,
        number_of_people: 2,
        reserved_at: Time.current
      )

      expect {
        harvest_experience.destroy
      }.to change { Reservation.count }.by(-1)
    end
  end
end