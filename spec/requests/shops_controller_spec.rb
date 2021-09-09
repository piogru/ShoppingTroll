require "rails_helper"

RSpec.describe ShopsController, type: :request do
  let(:shop1) { create(:shop) }
  let(:user) { create(:user) }
  describe "GET #index" do
    let!(:shop1) { create(:shop) }
    let!(:shop2) { create(:shop) }

    before do
      sign_in user
      get shops_path
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "response contains list of shops" do
      expect(response).to be_successful
      expect(response.body).to include(shop1.name)
      expect(response.body).to include(shop2.name)
    end
  end

  describe "#show" do
    before do
      sign_in user
    end
    context "if the shop has no products" do
      it "displays a message saying no products are available" do
        get shop_path(shop1)
        expect(response).to be_successful
        expect(response.body).to include("There are no products available in this shop")
      end
    end

    context "if the shop has available products" do
      let(:shop1) { create(:shop, :with_products) }

      it "returns list of categories with products" do
        get shop_path(shop1)
        expect(response).to be_successful
        shop1.products.each do |product|
          expect(response.body).to include(product.name)

          product.categories.each do |category|
            expect(response.body).to include(category.name)
          end
        end
      end
    end
  end

  context "when the user is not logged in" do
    it "redirects to login page when guest try to access shops index" do
      get(shops_path)
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response.body).to include ("You need to sign in or sign up before continuing.")
    end

    it "redirects to login page when guest try to access shop details" do
      get(shop_path(shop1))
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response.body).to include ("You need to sign in or sign up before continuing.")
    end
  end

  context "when the user is logged in" do
    before do
      sign_in user
    end

    it "renders shops index page that contains shops" do
      get(shops_path)
      expect(response.body).to include (I18n.t("shops.title"))
    end

    it "returns 404 when shop doesn't exist" do
      expect { get(shop_path(30)) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
