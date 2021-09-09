require "rails_helper"

RSpec.describe "Shopping list buying", type: :system, js: true do
  include Devise::Test::IntegrationHelpers

  let!(:owner) { create(:user) }
  let!(:shopping_list) { create(:shopping_list, owner: owner) }
  let!(:shop) { create(:shop) }
  let!(:product) { create(:product) }
  let!(:shop_product) { create(:shop_product, shop: shop, product: product) }
  let!(:shopping_list_shop_product) do
    create(
      :shopping_list_shop_product,
      shop_product:  shop_product,
      shopping_list: shopping_list
    )
  end

  before do
    driven_by :chrome_headless
    sign_in owner
  end

  describe "Bought checkbox" do
    before do
      visit "/shopping_lists/#{shopping_list.id}"
    end

    it "toggles the product's bought status" do
      find("#shopping_list_shop_product_bought").click
      expect(page).to have_css(".bought")
      shopping_list_shop_product.reload
      expect(shopping_list_shop_product).to be_bought

      find("#shopping_list_shop_product_bought").click
      expect(page).not_to have_css(".bought")
      shopping_list_shop_product.reload
      expect(shopping_list_shop_product).not_to be_bought
    end
  end
end
