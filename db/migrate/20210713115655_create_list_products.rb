class CreateListProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :shopping_list_products do |t|
      t.boolean :bought, default: false
      t.decimal :amount

      t.references :product, foreign_key: { on_delete: :cascade }, null: false, type: :integer
      t.references :shopping_list, foreign_key: { on_delete: :cascade }, null: false, type: :integer

      t.timestamps
    end
  end
end
