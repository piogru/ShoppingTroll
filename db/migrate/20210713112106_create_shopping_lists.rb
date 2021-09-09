class CreateShoppingLists < ActiveRecord::Migration[6.1]
  def change
    create_table :shopping_lists do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
