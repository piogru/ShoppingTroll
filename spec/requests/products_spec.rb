require "rails_helper"

RSpec.describe "Products", type: :request do
  let(:user) { create(:user) }
  let!(:product) { create(:product) }

  context "when the user is not logged in" do
    it "redirects to login page when guest try to access products index" do
      get(products_path)
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response.body).to include ("You need to sign in or sign up before continuing.")
    end

    it "redirects to login page when guest try to access product details" do
      get(product_path(product))
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response.body).to include ("You need to sign in or sign up before continuing.")
    end
  end

  context "when the user is logged in" do
    before do
      sign_in user
    end

    it "renders product index page that contains products" do
      get(products_path)
      expect(response.body).to include (product.name)
    end

    it "renders product details page" do
      get(product_path(product))
      expect(response.body).to include I18n.t("products.shops_with_products", name: product.name)
    end

    it "returns 404 when product doesn't exist" do
      expect { get(product_path(30)) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
