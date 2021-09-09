require "rails_helper"

RSpec.describe IngredientMapper, type: :service do
  let!(:product_1) { create(:product, name: "Good water",    capacity: 750, label: "ml", ml_to_g_rate: 1.0) }
  let!(:product_2) { create(:product, name: "Bad water",     capacity: 500, label: "ml", ml_to_g_rate: 1.0) }
  let!(:product_3) { create(:product, name: "Nice salt",     capacity: 200, label: "g",  ml_to_g_rate: 0.7) }
  let!(:product_4) { create(:product, name: "Spicy mustard", capacity: 100, label: "ml", ml_to_g_rate: 1.5) }
  let!(:shop) { create(:shop, :with_products, products: [product_1, product_2, product_3, product_4]) }

  it "returns appropriate product suggestions" do
    expect(subject.map(name: "water", quantity: 1500, unit: "ml")[:suggestions]).
      to eq [
        { shop_product: product_1.shop_products.first, quantity: 2 },
        { shop_product: product_2.shop_products.first, quantity: 3 }
      ]

    expect(subject.map(name: "salt", quantity: 700, unit: "g")[:suggestions]).
      to eq [
        { shop_product: product_3.shop_products.first, quantity: 4 }
      ]

    expect(subject.map(name: "mustard", quantity: 300, unit: "g")[:suggestions]).
      to eq [
        { shop_product: product_4.shop_products.first, quantity: 2 }
      ]

    expect(subject.map(name: "unknown", quantity: 200, unit: "glass")[:suggestions]).
      to eq []
  end
end
