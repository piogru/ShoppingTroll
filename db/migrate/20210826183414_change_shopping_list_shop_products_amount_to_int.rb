class ChangeShoppingListShopProductsAmountToInt < ActiveRecord::Migration[6.1]
  change_table :shopping_list_shop_products do |t|
    t.change :amount, :integer
  end
end
