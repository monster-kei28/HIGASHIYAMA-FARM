class PageImage < ApplicationRecord
  enum :page_type, {
    top: 0,
    guide: 1
  }

  enum :slot, {
    hero: 0,
    main: 1,
    sub_banner: 2
  }

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc, created_at: :asc) }
  scope :for_display, ->(page_type, slot) {
    public_send(page_type).published.where(slot: slot).ordered
  }

  validates :page_type, presence: true
  validates :slot, presence: true
  validates :image, presence: true
  validates :position, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }
end
