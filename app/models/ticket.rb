class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :category
  attr_accessor :user_attributes
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 70 }
  validates :content, presence: true, length: { maximum: 4096 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ticket_type, presence: true
  validates :location, length: { maximum: 50 }, presence: true
end
