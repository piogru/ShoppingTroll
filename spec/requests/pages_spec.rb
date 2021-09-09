require "rails_helper"

RSpec.describe "Pages", type: :request do
  let(:user) { create(:user) }

  context "when the user is not logged in" do
    it "renders index for guests " do
      get "/"
      expect(response.body).to include I18n.t("landing_page.message")
    end
  end

  context "when the user is logged in" do
    before do
      sign_in user
    end

    it "renders home for logged users " do
      get "/"
      expect(response.body).to include I18n.t("home.new_list_btn")
    end
  end
end
