class AddMlToGConversionRateToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :ml_to_g_rate, :decimal
  end
end
