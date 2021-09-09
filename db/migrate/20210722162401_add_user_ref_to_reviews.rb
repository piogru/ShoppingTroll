class AddUserRefToReviews < ActiveRecord::Migration[6.1]
  def change
    add_reference :reviews, :user, foreign_key: { on_delete: :cascade }, null: false, type: :integer
  end
end
