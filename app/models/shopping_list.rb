class ShoppingList < ApplicationRecord
  has_many :user_shopping_lists, dependent: :destroy
  has_many :users, through: :user_shopping_lists

  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  has_many :shopping_list_shop_products, foreign_key: "shopping_list_id"
  has_many :shop_products, through: :shopping_list_shop_products

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }

  rails_admin do
    edit do
      exclude_fields :products
    end
  end

  def shopping_list_shop_products_by_shop
    ShoppingList.
      where(id: id).
      includes(shopping_list_shop_products: { shop_product: %i(shop product) }).
      order("shops.id, shopping_list_shop_products.shop_product_id").
      first.
      shopping_list_shop_products.
      group_by { |slsp| slsp.shop_product.shop }
  end

  def total_price
    ShopProduct.joins(:shopping_list_shop_products).
      where("shopping_list_shop_products.shopping_list_id = :shopping_list_id", shopping_list_id: id).
      sum("shopping_list_shop_products.amount * shop_products.price")
  end
end
