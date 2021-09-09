require "rails_helper"
require "./spec/helpers/api_stub_helper"

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe "Recipe import", type: :request do
  let!(:user) { create(:user) }
  let!(:product1) { create(:product, name: "Rice") }
  let!(:product2) { create(:product, name: "Beans") }
  let!(:shop) { create(:shop, :with_products, products: [product1, product2]) }

  describe "GET import_form" do
    context "when the user is not logged in" do
      it "redirects to login page" do
        get recipe_import_form_path(1)
        expect(response).to redirect_to("/users/sign_in")
        follow_redirect!
        expect(response.body).to include ("You need to sign in or sign up before continuing.")
      end
    end

    context "when the user is logged in" do
      before do
        sign_in user
      end

      it "calls the recipe app API" do
        allow(RecipeFetcher).to receive(:call).and_call_original
        stub_recipe_api_request(1)
        get recipe_import_form_path(1)
        expect(RecipeFetcher).to have_received(:call).with("1")
      end

      it "returns NOT_FOUND status when recipe does not exist" do
        stub_recipe_api_request(0)
        get recipe_import_form_path(0)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:alert]).to eq("Couldn't find Recipe with 'id'=0")
      end
    end
  end

  describe "POST import_recipe" do
    context "when the user is signed in" do
      before { sign_in user }

      it "Creates a shopping list given valid params" do
        expect {
          post recipe_import_path, params: {
            title:    "My Recipe",
            products: ["#{product1.shop_products.first.id}:1", "#{product2.shop_products.first.id}:5"]
          }
        }.to change { ShoppingList.count }.by 1

        expect(response).to redirect_to shopping_list_path(ShoppingList.last)

        expect(
          ShoppingListShopProduct.
            find_by(shop_product: product1.shop_products.first).
            amount
        ).to eq 1

        expect(
          ShoppingListShopProduct.
            find_by(shop_product: product2.shop_products.first).
            amount
        ).to eq 5
      end

      it "Creates an empty list if no products are given" do
        expect {
          post recipe_import_path, params: { title: "My Recipe" }
        }.to change { ShoppingList.count }.by 1

        expect(response).to redirect_to shopping_list_path(ShoppingList.last)
      end

      it "Doesn't create a shopping list given invalid params" do
        expect {
          post recipe_import_path, params: {
            title:    "My Recipe",
            products: ["junk"]
          }
        }.not_to change { ShoppingList.count }

        expect(response).to redirect_to root_path
      end
    end

    context "when the user is not signed in" do
      it "Redirects to the sign-in page" do
        post recipe_import_path, params: {
          title:    "My Recipe",
          products: ["#{product1.shop_products.first.id}:1", "#{product2.shop_products.first.id}:5"]
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
