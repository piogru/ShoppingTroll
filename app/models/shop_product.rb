class ShopProduct < ApplicationRecord
  belongs_to :shop
  belongs_to :product

  has_many :shopping_list_shop_products
  has_many :shopping_lists, through: :shopping_list_shop_products

  validates :price, presence: true

  scope :matching, -> (search_term) do
    joins(:product).
      merge(Product.matching(search_term)).
      distinct
  end

  def self.before_import_find(record)
    # translate product and shop names to id's before importing
    record[:product_id] = Product.find_by(name: record[:product]).id
    record[:shop_id] = Shop.find_by(name: record[:shop]).id
  end
end
