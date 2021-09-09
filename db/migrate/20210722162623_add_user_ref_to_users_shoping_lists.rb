class AddUserRefToUsersShopingLists < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_shopping_lists, :user, foreign_key: { on_delete: :cascade }, null: false, type: :integer
  end
end
