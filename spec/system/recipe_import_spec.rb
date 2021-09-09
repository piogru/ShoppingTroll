require "rails_helper"
require "./spec/helpers/api_stub_helper"

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe "Recipe import", type: :system, js: true do
  include Devise::Test::IntegrationHelpers

  before { driven_by :chrome_headless }

  before(:all) do
    create(:shop, :with_products, products: [
      create(:product, name: "Good water", capacity: 500.0,  label: "ml", ml_to_g_rate: 1.0),
      create(:product, name: "Nice salt",  capacity: 200.0,  label: "g",  ml_to_g_rate: 0.75),
      create(:product, name: "Cool flour", capacity: 1000.0, label: "g",  ml_to_g_rate: 0.5)
    ])
  end

  let!(:user) { create(:user) }

  describe "Import form" do
    before do
      stub_recipe_api_request(1)
      sign_in user
    end

    it "creates an appropriate shopping list" do
      visit recipe_import_form_path(1)

      expect(page).
        to have_css("option", text: "Good water").
        and have_css("option", text: "Nice salt").
        and have_css("option", text: "Cool flour")

      find_field("Title").fill_in(with: "My Recipe")

      find('form[action="/import-recipe"] input[type=submit]').click

      expect(page).to have_css("h1", text: "My Recipe")
    end
  end
end
