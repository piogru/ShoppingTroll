require "rails_helper"

RSpec.describe "Shop reviews", type: :system, js: true do
  let!(:user_1) { create(:user, email: "user1@example.com") }
  let!(:user_2) { create(:user, email: "user2@example.com", nickname: "name1") }
  let!(:user_3) { create(:user, email: "user3@example.com", nickname: "name1") }
  let!(:admin) { create(:user, email: "admin@example.com", admin: true) }
  let!(:shop) { create(:shop) }
  let!(:review_1) { create(:review, user: user_2, shop: shop) }
  let!(:review_2) { create(:review, user: user_3, shop: shop) }
  let(:review_attrs) { attributes_for(:review) }

  before do
    driven_by :chrome_headless
  end

  describe "User adding reviews" do
    before do
      sign_in user_1
      visit shop_path(shop)
    end

    context "when data is valid" do
      it "creates review" do
        # select 1 star on review
        stars = page.all("label")
        stars[0].click

        find_field("Title").fill_in(with: "Sample title")
        find_field("Description").fill_in(with: "Sample description")
        find_button("Create Review").click
        expect(page).to have_css(".alert-primary", text: "Review created")
      end
    end

    context "when data is invalid" do
      it "flashes alert" do
        stars = page.all("label", minimum: 5)
        stars[0].click

        find_button("Create Review").click
        expect(page).to have_css(".alert-danger", text: "Could not create review")
      end
    end
  end

  describe "User editing reviews" do
    before do
      sign_in user_2
      visit shop_path(shop)
      click_link(href: "/shops/1/reviews/1/edit")
    end

    context "when data is valid" do
      it "creates review" do
        # select 1 star on review
        stars = page.all("label", wait: true)
        stars[0].click

        find_field("Title").fill_in(with: "Sample title edited")
        find_field("Description").fill_in(with: "Sample description edited")
        find_button("Update Review").click
        expect(page).to have_css(".alert-primary", text: "Review updated")
      end
    end

    context "when data is invalid" do
      it "flashes alert" do
        fill_in "Title", with: ""
        find_button("Update Review").click
        expect(page).to have_css(".alert-danger", text: "Could not update review")
      end
    end
  end

  describe "User deleting reviews" do
    before do
      sign_in user_2
      visit shop_path(shop)
    end

    context "when confirmed" do
      it "deletes review" do
        delete_buttons = page.all("a[data-method='delete']")
        delete_buttons[0].click
        a = page.driver.browser.switch_to.alert
        a.accept

        expect(page).to have_css(".alert-primary", text: "Review deleted")
      end
    end
  end

  describe "Admin deleting other user reviews" do
    before do
      sign_in admin
      visit shop_path(shop)
    end

    context "when confirmed" do
      it "deletes review" do
        delete_buttons = page.all("a[data-method='delete']")
        delete_buttons[1].click
        a = page.driver.browser.switch_to.alert
        a.accept

        expect(page).to have_css(".alert-primary", text: "Review deleted")
      end
    end
  end

end
