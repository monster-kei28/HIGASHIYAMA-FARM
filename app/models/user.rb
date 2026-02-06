class User < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, presence: true, on: :update

  validates :phone_number,
            uniqueness: true,
            presence: true,
            format: { with: /\A\d{10,11}\z/, message: "はハイフンなしの10桁または11桁で入力してください" },
            on: :update
end
