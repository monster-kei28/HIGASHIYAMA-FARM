class Admin < ApplicationRecord
  belongs_to :user, optional: true
  validates :uid, presence: true, uniqueness: true
end
