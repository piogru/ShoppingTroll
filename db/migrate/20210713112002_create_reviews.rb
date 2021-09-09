class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :title, null: false
      t.text :description
      t.integer :stars

      t.references :shop, foreign_key: { on_delete: :cascade }, null: false, type: :integer

      t.timestamps
    end
  end
end
