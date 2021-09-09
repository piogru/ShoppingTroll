require "rails_helper"

RSpec.describe "Shopping list shop product", type: :system, js: true do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let!(:shopping_list) { create(:shopping_list, owner: user) }
  let!(:shop) { create(:shop) }
  let!(:product_1) { create(:product) }
  let!(:category) { create(:category, product_ids: product_1.id) }
  let!(:shop_product) { create(:shop_product, shop: shop, product: product_1) }

  before do
    driven_by :chrome_headless
    sign_in user
  end

  describe "Adding product to shopping list from product's page" do
    before do
      visit products_path
      click_link(href: "/products/1")
      click_link(href: "/shop_products/1/add_to_shopping_list")
    end

    context "when form is valid" do
      it "adds product and hides modal" do
        select "#{shopping_list.name}", from: :shopping_list_shop_product_shopping_list_id
        find_field("Amount").fill_in(with: "5")

        find_button("Add to shopping list").click
        expect(page).to have_css(".alert-primary", text: "Product successfully added to shopping list")
        expect(page).to have_selector("#modal-window", visible: false)
      end
    end

    context "when form is invalid" do
      it "flashes alert" do
        find_button("Add to shopping list").click
        expect(page).to have_css("#shopping_listInvalidFeedback", text: "Shopping list must exist")
        expect(page).to have_css("#amountInvalidFeedback", text: "Amount can't be blank, Amount is not a number")
      end
    end
  end

  describe "Adding product to shopping list from shop's page" do
    before do
      visit shops_path
      click_link(href: "/shops/1")
      find_button("#{category.name}").click
      click_link(href: "/shop_products/1/add_to_shopping_list")
    end

    context "when form is valid" do
      it "adds product and hides modal" do
        select "#{shopping_list.name}", from: :shopping_list_shop_product_shopping_list_id
        find_field("Amount").fill_in(with: "5")

        find_button("Add to shopping list").click
        expect(page).to have_css(".alert-primary", text: "Product successfully added to shopping list")
        expect(page).to have_selector("#modal-window", visible: false)
      end

      it "increases amount when product is already on list" do
        select "#{shopping_list.name}", from: :shopping_list_shop_product_shopping_list_id
        find_field("Amount").fill_in(with: "5")
        find_button("Add to shopping list").click

        click_link(href: "/shop_products/1/add_to_shopping_list")
        select "#{shopping_list.name}", from: :shopping_list_shop_product_shopping_list_id
        find_field("Amount").fill_in(with: "2")
        find_button("Add to shopping list").click

        expect(page).to have_css(".alert-primary", text: "Product amount updated to 7")
      end
    end

    context "when form is invalid" do
      it "flashes alert" do
        find_button("Add to shopping list").click
        expect(page).to have_css("#shopping_listInvalidFeedback", text: "Shopping list must exist")
        expect(page).to have_css("#amountInvalidFeedback", text: "Amount can't be blank, Amount is not a number")
      end
    end
  end

  describe "Editing product information in shopping list" do
    let!(:product_2) { create(:product) }
    let!(:shopping_list_shop_product_1) {
      create(:shopping_list_shop_product, shopping_list: shopping_list,
                                          shop_product:  shop_product) }
    let!(:shopping_list_shop_product_2) {
      create(:shopping_list_shop_product, shopping_list: shopping_list,
                                          shop_product:  create(:shop_product, product: product_2, shop: shop)) }

    before do
      visit shopping_list_path(shopping_list)
      click_link(href: "/shopping_list_shop_products/1/edit")
    end

    context "when form is valid" do
      it "edits product and hides modal" do
        fill_in "Amount", with: "1234.0"

        find_button("Update").click
        expect(page).to have_css(".alert-primary", text: "Product information edited successfully")
        expect(page).to have_selector("#modal-window", visible: false)
      end
    end

    context "when editing multiple products" do
      let!(:shopping_list_2) { create(:shopping_list, owner: user, name: "Shopping list") }

      it "edits product and hides modal" do
        fill_in "Amount", with: "1234.0"
        find_button("Update").click
        expect(page).to have_css(".alert-primary", text: "Product information edited successfully")
        expect(page).to have_selector("#modal-window", visible: false)

        click_link(href: "/shopping_list_shop_products/2/edit")
        select "#{shopping_list_2.name}", from: :shopping_list_shop_product_shopping_list_id
        checkboxes = find_all("#shopping_list_shop_product_bought")
        checkboxes[2].check
        find_button("Update").click
        expect(page).to have_css(".alert-primary", text: "Product information edited successfully")
        expect(page).to have_selector("#modal-window", visible: false)
      end
    end

    context "when form is invalid" do
      it "displays feedback" do
        select "Select shopping list", from: :shopping_list_shop_product_shopping_list_id
        fill_in "Amount", with: ""
        find_button("Update").click

        expect(page).to have_css("#shopping_listInvalidFeedback", text: "Shopping list must exist")
        expect(page).to have_css("#amountInvalidFeedback", text: "Amount can't be blank, Amount is not a number")
      end
    end
  end

  describe "Deleting product from shopping list" do
    let!(:product_2) { create(:product) }
    let!(:shopping_list_shop_product_1) { create(:shopping_list_shop_product,
      shopping_list: shopping_list,
      shop_product:  shop_product) }
    let!(:shopping_list_shop_product_2) { create(:shopping_list_shop_product,
      shopping_list: shopping_list,
      shop_product:  create(:shop_product,
product: product_2, shop: shop)) }

    before do
      visit shopping_list_path(shopping_list)
      delete_buttons = page.all("a[data-method='delete']")
      delete_buttons[1].click
    end

    context "when delete confirmed" do
      it "deletes product from list" do
        a = page.driver.browser.switch_to.alert
        a.accept

        expect(page).not_to have_css(".alert-primary", text: "Product removed successfully")
        expect(page).not_to have_css(".d-flex", text: product_1.name)
      end
    end

    context "when deleting multiple products" do
      it "deletes all selected products from shopping list" do
        a = page.driver.browser.switch_to.alert
        a.accept
        expect(page).to have_css(".alert-primary", text: "Product removed successfully")

        delete_buttons = page.all("a[data-method='delete']")
        delete_buttons[1].click
        a = page.driver.browser.switch_to.alert
        a.accept

        expect(page).to have_css(".alert-primary", text: "Product removed successfully")
        expect(page).not_to have_css(".d-flex", text: product_1.name)
        expect(page).not_to have_css(".d-flex", text: product_2.name)
      end
    end

    context "when delete is canceled" do
      it "does nothing" do
        a = page.driver.browser.switch_to.alert
        a.dismiss

        expect(page).to have_css(".d-flex", text: product_1.name)
      end
    end
  end
end
