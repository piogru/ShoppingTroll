require "rails_helper"

RSpec.describe ShoppingListShopProductsController, type: :request do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let!(:shopping_list) { create(:shopping_list, owner: user) }
  let!(:shop) { create(:shop) }
  let!(:product) { create(:product) }
  let!(:shop_product) { create(:shop_product, shop: shop, product: product) }

  describe "GET #new" do
    context "when user is signed in" do
      before do
        sign_in user
      end

      it "is successful" do
        get add_to_shopping_list_path(shop_product), xhr: true
        expect(response).to be_successful
      end

      it "contains addition form for selected product" do
        get add_to_shopping_list_path(shop_product), xhr: true
        expect(response).to be_successful
        expect(response.body).to include("Add product to shopping list")
        expect(response.body).to include("#{shop_product.product.name}")
      end
    end

    context "when user is not signed in" do
      it "returns unauthorized status code" do
        get add_to_shopping_list_path(shop_product), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST #create" do
    let(:params) {
 { shopping_list_shop_product: { shopping_list_id: shopping_list.id, shop_product_id: shop_product.id, amount: 1,
bought: false } } }

    context "when product addition to shopping list is successful" do
      before do
        sign_in user
      end

      it "flashes notice" do
        post create_shopping_list_shop_product_path(shop_product), xhr: true, params: params
        expect(flash[:notice]).to eq("Product successfully added to shopping list")
      end
    end

    context "when product could not be added to shopping list" do
      let(:params) {
 { shopping_list_shop_product: { shopping_list_id: nil, shop_product_id: shop_product.id, amount: nil,
bought: false } } }

      before do
        sign_in user
      end

      it "shows validation feedback" do
        post create_shopping_list_shop_product_path(shop_product), xhr: true, params: params
        expect(response.body).to include("Shopping list must exist")
        expect(response.body).to include("Amount can&#39;t be blank, Amount is not a number")
      end
    end

    context "when the user is not signed in" do
      it "returns unauthorized status code" do
        post create_shopping_list_shop_product_path(shop_product), xhr: true, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is signed in but dont have access to shopping list" do
      let!(:shopping_list_shop_product) {
 create(:shopping_list_shop_product, shopping_list: shopping_list, shop_product: shop_product) }
      let(:params) {
 { shopping_list_shop_product: { shopping_list_id: shopping_list.id, shop_product_id: shop_product.id, amount: 1,
bought: false } } }

      before do
        sign_in user_2
      end

      it "flashes alert when trying to add product" do
        post create_shopping_list_shop_product_path(shop_product), xhr: true, params: params
        expect(flash[:alert]).to eq(I18n.t("pundit.not_authorized"))
      end
    end
  end

  describe "GET #edit" do
    let!(:product_2) { create(:product) }
    let!(:shopping_list_shop_product_1) { create(:shopping_list_shop_product,
      shopping_list: shopping_list,
      shop_product:  shop_product) }

    context "when user is signed in" do
      before do
        sign_in user
      end

      it "is successful" do
        get edit_shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true
        expect(response).to be_successful
      end

      it "contains edit form for selected product" do
        get edit_shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true
        expect(response).to be_successful
        expect(response.body).to include("Edit product information")
        expect(response.body).to include("#{shop_product.product.name}")
      end
    end

    context "when user is not signed in" do
      it "returns unauthorized status code" do
        get edit_shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH #update" do
    let!(:shopping_list_shop_product_1) { create(:shopping_list_shop_product,
      shopping_list: shopping_list,
      shop_product:  shop_product) }
    let(:params) {
 { shopping_list_shop_product: { shopping_list_id: shopping_list.id, shop_product_id: shop_product.id, amount: 1010.0,
bought: true } } }

    context "when product information edit is successful" do
      before do
        sign_in user
      end

      it "flashes notice" do
        patch shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true, params: params
        expect(flash[:notice]).to eq("Product information edited successfully")
      end
    end

    context "when product information could not be edited" do
      let(:params) {
 { shopping_list_shop_product: { shopping_list_id: nil, shop_product_id: shop_product.id, amount: nil,
bought: false } } }

      before do
        sign_in user
      end

      it "shows validation feedback" do
        patch shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true, params: params
        expect(response.body).to include("Shopping list must exist")
        expect(response.body).to include("Amount can&#39;t be blank, Amount is not a number")
      end
    end

    context "when the user is not signed in" do
      it "returns unauthorized status code" do
        patch shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is signed in but does not have access to shopping list" do
      let(:params) {
 { shopping_list_shop_product: { shopping_list_id: shopping_list.id, shop_product_id: shop_product.id, amount: 1,
bought: false } } }

      before do
        sign_in user_2
      end

      it "flashes alert when trying to update" do
        patch shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true, params: params
        expect(flash[:alert]).to eq(I18n.t("pundit.not_authorized"))
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:shopping_list_shop_product_1) { create(:shopping_list_shop_product,
      shopping_list: shopping_list,
      shop_product:  shop_product) }

    context "when user is logged in" do
      before do
        sign_in user
      end

      it "deletes product from shopping list" do
        delete shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true
        expect { shopping_list_shop_product_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is not signed in" do
      it "returns unauthorized status code" do
        delete shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user does not have access to shopping list" do
      before do
        sign_in user_2
      end

      it "returns unauthorized status code" do
        delete shopping_list_shop_product_path(shopping_list_shop_product_1), xhr: true
        expect(ShoppingListShopProduct.where(id: shopping_list_shop_product_1.id)).to exist
      end
    end
  end
end
