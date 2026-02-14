class Admin < ApplicationRecord
  validates :uid, presence: true, uniqueness: true
end
