class Product < ApplicationRecord
  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many :shop_products
  has_many :shops, through: :shop_products

  validates :name, presence: true, length: { minimum: 3 }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :label, presence: true
  validates :ml_to_g_rate, presence: true, numericality: { greater_than: 0 }

  scope :matching, -> (search_term) do
    where("name ILIKE ?", "%#{search_term}%").distinct
  end
end
