class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories

  validates :name, presence: true, uniqueness: true, length: { minimum: 3 }
end
