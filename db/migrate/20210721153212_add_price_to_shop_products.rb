class AddPriceToShopProducts < ActiveRecord::Migration[6.1]
  change_table:shop_products do |t|
    t.decimal :price, precision: 10, scale: 2
  end
end
