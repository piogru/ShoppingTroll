class CreateProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_categories do |t|
      t.references :product, foreign_key: { on_delete: :cascade }, null: false
      t.references :category, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
  end
end
