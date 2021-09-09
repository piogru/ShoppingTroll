class ChangeShoppingListProductAssociation < ActiveRecord::Migration[6.1]
  def change
    change_table :shopping_list_products do |t|
      t.remove_references :product
    end

    add_reference :shopping_list_products, :shop_product, index: true, foreign_key: { on_delete: :cascade }, null: false


    rename_table :shopping_list_products, :shopping_list_shop_products
  end
end
