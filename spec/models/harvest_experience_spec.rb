require 'rails_helper'

RSpec.describe HarvestExperience, type: :model do
  describe 'validations' do
    it 'title があれば有効である' do
      harvest_experience = build(:harvest_experience)
      expect(harvest_experience).to be_valid
    end

    it 'title がない場合は無効である' do
      harvest_experience = build(:harvest_experience, title: nil)
      expect(harvest_experience).to be_invalid
      expect(harvest_experience.errors[:title]).to include("can't be blank")
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
      harvest_experience = create(:harvest_experience)
      create(:reservation, harvest_experience: harvest_experience)

      expect {
        harvest_experience.destroy
      }.to change { Reservation.count }.by(-1)
    end
  end
end
