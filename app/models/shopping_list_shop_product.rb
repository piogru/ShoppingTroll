class ShoppingListShopProduct < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :shop_product

  validates :bought, inclusion: [true, false]
  validates :amount, presence: true, numericality: { greater_than: 0 }

  scope :bought, -> { where(bought: true) }

  def title
    if shop_product && shopping_list
      "Product: #{shop_product.product.name} | Shopping list: #{shopping_list.name}"
    end
  end

  def price
    amount * shop_product.price
  end
end
