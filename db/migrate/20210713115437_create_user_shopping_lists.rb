class CreateUserShoppingLists < ActiveRecord::Migration[6.1]
  def change
    create_table :user_shopping_lists do |t|
      t.references :shopping_list, foreign_key: { on_delete: :cascade }, null: false, type: :integer

      t.timestamps
    end
  end
end
