class ChangeColumnNameInUsersTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :nick, :nickname
  end
end
