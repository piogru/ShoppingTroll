class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :capacity, precision: 10, scale: 2, null: false
      t.string :label, null: false
      t.timestamps
    end
  end
end
