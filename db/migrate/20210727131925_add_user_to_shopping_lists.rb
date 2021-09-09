class AddUserToShoppingLists < ActiveRecord::Migration[6.1]
  def change
    add_reference :shopping_lists, :owner, foreign_key: { to_table: :users, on_delete: :cascade }, null: false, type: :integer
  end
end
