class ChangeMlToGRateToNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :products, :ml_to_g_rate, false
    change_column_default :products, :ml_to_g_rate, 1.to_d
    change_column :products, :ml_to_g_rate, :decimal, precision: 6, scale: 4
  end
end
