require "rails_helper"

RSpec.describe "Categories", type: :request do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }

  context "when the user is not logged in" do
    it "redirects to login page when guest try to access categories index" do
      get(categories_path)
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response.body).to include ("You need to sign in or sign up before continuing.")
    end

    it "redirects to login page when guest try to access category details" do
      get(category_path(category))
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response.body).to include ("You need to sign in or sign up before continuing.")
    end
  end

  context "when the user is logged in" do
    before do
      sign_in user
    end

    it "renders category index page that contains categories" do
      get(categories_path)
      expect(response.body).to include (I18n.t("categories.all"))
    end

    it "renders category details page" do
      get(category_path(category))
      expect(response.body).to include I18n.t("categories.products_in_category", name: category.name)
    end

    it "returns 404 when category doesn't exist" do
      expect { get(category_path(30)) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
