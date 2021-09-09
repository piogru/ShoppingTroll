class Shop < ApplicationRecord
  has_many :shop_products
  has_many :products, through: :shop_products

  has_many :reviews

  validates :name, presence: true, uniqueness: true, length: { minimum: 3 }

  # Fetches all categories associated with products included in the shop
  def categories
    Category.
      joins(:product_categories).
      merge(
        ProductCategory.
        where(product_id: products.ids)
      ).
      distinct
  end

  # Calculates the average number of stars among reviews of the shop
  def average_rating
    reviews.average(:stars).to_d
  end
end
