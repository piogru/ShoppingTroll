require "rails_helper"

RSpec.describe ShopProduct, type: :model do
  describe "validations" do
    it {  is_expected.to validate_presence_of(:price) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:shop) }
    it { is_expected.to have_many(:shopping_lists).through(:shopping_list_shop_products) }
  end

  describe "scopes" do
    describe "matching" do
      let!(:product_1) { create(:product, name: "Good water") }
      let!(:product_2) { create(:product, name: "Nice water") }
      let!(:product_3) { create(:product, name: "Nice salt") }
      let!(:shop) { create(:shop, :with_products, products: [product_1, product_2, product_3]) }

      it "returns the correct shop products" do
        expect(ShopProduct.matching("water")).
          to include(product_1.shop_products.first, product_2.shop_products.first).
          and not_include(product_3.shop_products.first)
      end
    end
  end
end
