class CreateShopProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :shop_products do |t|
      t.references :product, foreign_key: { on_delete: :cascade }, null: false
      t.references :shop, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
  end
end
