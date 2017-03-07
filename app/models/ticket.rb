class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :category
  mount_uploader :picture, PictureUploader
  attr_accessor :user_attributes
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 70 }
  validates :content, presence: true, length: { maximum: 4096 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ticket_type, presence: true
  validates :location, length: { maximum: 50 }, presence: true
  validate :picture_size
  validate :not_main_category

  def not_main_category
    if self.category.main?
      errors.add(:category_id, "should choose subcategory")
    end
  end
  
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
  
  def find_next(up_at, cat_id)
    Ticket.where("updated_at < ? and category_id = ? ", up_at, cat_id).first || nil
  end

  def find_previous(up_at, cat_id)
    Ticket.where("updated_at > ? and category_id = ? ", up_at, cat_id).last || nil
  end
end
