require "rails_helper"

RSpec.describe ShoppingList, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).
        is_at_least(3).is_at_most(100)
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:users).through(:user_shopping_lists) }
    it { is_expected.to have_many(:user_shopping_lists) }

    it { is_expected.to belong_to(:owner) }

    it { is_expected.to have_many(:shopping_list_shop_products) }
    it { is_expected.to have_many(:shop_products).through(:shopping_list_shop_products) }
  end

  describe "methods" do
    let!(:user) { create(:user) }
    let!(:shop) { create(:shop) }
    let!(:shop_2) { create(:shop) }
    let!(:product) { create(:product) }
    let!(:product_2) { create(:product) }
    let!(:shop_product) { create(:shop_product, shop: shop, product: product) }
    let!(:shop_product_2) { create(:shop_product, shop: shop, product: product_2) }
    let!(:shop_product_3) { create(:shop_product, shop: shop_2, product: product_2, price: (3.5).to_d) }

    describe "#shopping_list_shop_products_by_shop" do
      let!(:products) { 6.times.collect { create(:product) } }
      # Pick arbitrary products for each shop to test ordering
      let!(:shop_1) { create(:shop, :with_products, products: products.values_at(4, 2, 0)) }
      let!(:shop_2) { create(:shop, :with_products, products: products.values_at(1, 5, 3, 4)) }
      let!(:shopping_list) {
        create(
          :shopping_list, :with_shop_products,
          shop_products: products.
            map { |product| product.shop_products.first }
        )
      }

      let(:result) { shopping_list.shopping_list_shop_products_by_shop }

      it "includes all products associated with the shopping list once" do
        expect(result).to include(shop_1, shop_2)
        expect(result.flat_map { |_, slsps| slsps }).
          to eq shopping_list.shopping_list_shop_products.
            sort_by { |slsp| [slsp.shop_product.shop_id, slsp.shop_product_id] }
      end
    end

    describe "#total_price" do
      before do
        create(:shopping_list_shop_product, shopping_list: shopping_list, shop_product: shop_product)
        create(:shopping_list_shop_product, shopping_list: shopping_list, shop_product: shop_product_2)
        create(:shopping_list_shop_product, shopping_list: shopping_list, shop_product: shop_product_3)
      end

      subject(:shopping_list) { create(:shopping_list, owner: user) }

      it "calculates total price" do
        expect(subject.total_price).to eq(23.5)
      end
    end
  end
end
