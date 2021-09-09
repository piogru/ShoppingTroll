require "rails_helper"

RSpec.describe "Capacity calculator", type: :system, js: true do
  let!(:product) { create(:product) }

  before do
    driven_by :chrome_headless

    visit root_path
    if page.has_css?(".navbar-toggler-icon", wait: 0)
      page.find(".navbar-toggler-icon").click
    end
    page.find("#calculator-link").click
  end

  describe "Capacity calculator" do
    context "given ml label with product and input" do
      it "returns results" do
        choose(:label, option: :ml, wait: true)
        select "#{product.name}", from: :product_id
        find_field(:input).fill_in(with: "100")

        find("#capacity-submit").click
        expect(page).to have_css(".inline", text: "Ml:")
        expect(page).to have_css(".inline", text: "Glasses:")
        expect(page).to have_css(".inline", text: "Tablespoons:")
        expect(page).to have_css(".inline", text: "Teaspoons:")
        expect(page).to have_css(".inline", text: "Grams:")
      end
    end

    context "given glass label with product and input" do
      it "returns results" do
        choose(:label, option: :glass, wait: true)
        select "#{product.name}", from: :product_id
        find_field(:input).fill_in(with: "5")

        find("#capacity-submit").click
        expect(page).to have_css(".inline", text: "Ml:")
        expect(page).to have_css(".inline", text: "Glasses:")
        expect(page).to have_css(".inline", text: "Tablespoons:")
        expect(page).to have_css(".inline", text: "Teaspoons:")
        expect(page).to have_css(".inline", text: "Grams:")
      end
    end

    context "given tablespoon label with product and input" do
      it "returns results" do
        choose(:label, option: :tablespoon, wait: true)
        select "#{product.name}", from: :product_id
        find_field(:input).fill_in(with: "10")

        find("#capacity-submit").click
        expect(page).to have_css(".inline", text: "Ml:")
        expect(page).to have_css(".inline", text: "Glasses:")
        expect(page).to have_css(".inline", text: "Tablespoons:")
        expect(page).to have_css(".inline", text: "Teaspoons:")
        expect(page).to have_css(".inline", text: "Grams:")
      end
    end

    context "given teaspoon label with product and input" do
      it "returns results" do
        choose(:label, option: :teaspoon, wait: true)
        select "#{product.name}", from: :product_id
        find_field(:input).fill_in(with: "10")

        find("#capacity-submit").click
        expect(page).to have_css(".inline", text: "Ml:")
        expect(page).to have_css(".inline", text: "Glasses:")
        expect(page).to have_css(".inline", text: "Tablespoons:")
        expect(page).to have_css(".inline", text: "Teaspoons:")
        expect(page).to have_css(".inline", text: "Grams:")
      end
    end

    context "given gram label with product and input" do
      it "returns results" do
        input = "100"
        choose(:label, option: :gram, wait: true)
        select "#{product.name}", from: :product_id
        find_field(:input).fill_in(with: input)

        find("#capacity-submit").click
        expect(page).to have_css(".inline", text: "Ml:")
        expect(page).to have_css(".inline", text: "Glasses:")
        expect(page).to have_css(".inline", text: "Tablespoons:")
        expect(page).to have_css(".inline", text: "Teaspoons:")
        expect(page).to have_css(".inline", text: "Grams:")
      end
    end

    context "given no label" do
      it "flashes alert" do
        input = "100"
        select "#{product.name}", from: :product_id
        find_field(:input).fill_in(with: input)

        find("#capacity-submit").click
        expect(page).to have_css(".alert-danger", text: "Please select label and product")
      end
    end

    context "given no product" do
      it "flashes alert" do
        input = "100"
        choose(:label, option: :ml, wait: true)
        find_field(:input).fill_in(with: input)

        find("#capacity-submit").click
        expect(page).to have_css(".alert-danger", text: "Please select label and product")
      end
    end

    context "given prohibited characters in input" do
      it "stops prohibited characters from being entered " do
        input = "asdf-123"
        find_field(:input).fill_in(with: input)

        expect(find_field(:input).value).to eq "123"
      end
    end
  end

  describe "Form calculator" do
    context "when form type selection is missing" do
      it "flashes alert" do
        find("#form-submit").click
        expect(page).to have_css(".alert-danger", text: "Please select form types")
      end

      it "flashes alert" do
        choose(:recipe_form, option: "mold", wait: true)

        find("#form-submit").click
        expect(page).to have_css(".alert-danger", text: "Please select form types")
      end

      it "flashes alert" do
        choose(:home_form, option: "caketin", wait: true)

        find("#form-submit").click
        expect(page).to have_css(".alert-danger", text: "Please select form types")
      end
    end

    context "when both form types are selected with missing input" do
      it "flashes alert" do
        choose(:recipe_form, option: "mold", wait: true)
        choose(:home_form, option: "caketin", wait: true)

        find_field(:recipe_form_x).fill_in(with: "11")
        find_field(:home_form_x).fill_in(with: "12")

        find("#form-submit").click
        expect(page).to have_css(".alert-danger", text: "Please input form dimensions")
      end

      it "flashes alert" do
        choose(:recipe_form, option: "mold", wait: true)
        choose(:home_form, option: "caketin", wait: true)

        find_field(:home_form_x).fill_in(with: 12)

        find("#form-submit").click
        expect(page).to have_css(".alert-danger", text: "Please input form dimensions")
      end
    end

    context "given prohibited characters in input" do
      before do
        @input = "asdf-123"
      end

      it "stops prohibited characters from being entered " do
        find_field(:recipe_form_x).fill_in(with: @input)

        expect(find_field(:recipe_form_x).value).to eq "123"
      end

      it "stops prohibited characters from being entered " do
        find_field(:recipe_form_y).fill_in(with: @input)

        expect(find_field(:recipe_form_y).value).to eq "123"
      end

      it "stops prohibited characters from being entered " do
        find_field(:home_form_x).fill_in(with: @input)

        expect(find_field(:home_form_x).value).to eq "123"
      end

      it "stops prohibited characters from being entered " do
        find_field(:home_form_y).fill_in(with: @input)

        expect(find_field(:home_form_y).value).to eq "123"
      end
    end

    context "when both form types are selected and input is given" do
      it "returns results" do
        choose(:recipe_form, option: "mold", wait: true)
        choose(:home_form, option: "caketin", wait: true)

        find_field(:recipe_form_x).fill_in(with: "10")
        find_field(:recipe_form_y).fill_in(with: "10")
        find_field(:home_form_x).fill_in(with: "10")

        find("#form-submit").click
        expect(page).to have_css(".inline", text: "Product Ratio:")
      end

      it "returns results" do
        choose(:recipe_form, option: "mold", wait: true)
        choose(:home_form, option: "mold", wait: true)

        find_field(:recipe_form_x).fill_in(with: "10")
        find_field(:recipe_form_y).fill_in(with: "10")
        find_field(:home_form_x).fill_in(with: "10")
        find_field(:home_form_y).fill_in(with: "10")

        find("#form-submit").click
        expect(page).to have_css(".inline", text: "Product Ratio:")
      end

      it "returns results" do
        choose(:recipe_form, option: "caketin", wait: true)
        choose(:home_form, option: "mold", wait: true)

        find_field(:recipe_form_x).fill_in(with: "10")
        find_field(:home_form_x).fill_in(with: "10")
        find_field(:home_form_y).fill_in(with: "10")

        find("#form-submit").click
        expect(page).to have_css(".inline", text: "Product Ratio:")
      end

      it "returns results" do
        choose(:recipe_form, option: "caketin", wait: true)
        choose(:home_form, option: "caketin", wait: true)

        find_field(:recipe_form_x).fill_in(with: "10")
        find_field(:home_form_x).fill_in(with: "10")

        find("#form-submit").click
        expect(page).to have_css(".inline", text: "Product Ratio:")
      end
    end
  end
end
