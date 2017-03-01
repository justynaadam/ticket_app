class Category < ApplicationRecord
  has_many :subcategories, class_name: "Category",
                          foreign_key: "main_id",
                          dependent: :destroy
  belongs_to :main, optional: true, class_name: "Category"

  has_many :tickets
  validates :text, presence: true, length: { maximum: 30 }
end
