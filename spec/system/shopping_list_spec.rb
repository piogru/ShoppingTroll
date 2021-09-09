require "rails_helper"

RSpec.describe "Shopping lists", type: :system, js: true do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }

  before do
    driven_by :chrome_headless
    sign_in user
  end

  context "when user doesn't have any lists" do
    before do
      visit root_path
    end

    it "displays create button" do
      expect(page).to have_css(".btn-purple", text: "Create new list")
    end

    it "user is able to create new list with valid data" do
      click_on "Create new list", match: :first
      fill_in "shopping_list[name]", with: "My 1st list"
      click_button "Create"
      expect(page).to have_text("Shopping list created")
    end

    it "user is unable to create new list with valid data" do
      click_on "Create new list", match: :first
      fill_in "shopping_list[name]", with: "Aa"
      click_button "Create"
      expect(page).to have_text("Name is too short (minimum is 3 characters)")
    end
  end

  context "when user has lists" do
    let!(:shopping_list) { create(:shopping_list, owner: user) }
    let!(:shopping_list_2) { create(:shopping_list, name: "Dinner ingredients" , owner: user_2) }
    let!(:user_shopping_list) { create(:user_shopping_list, user: user, shopping_list: shopping_list_2) }

    describe "index" do
      before do
        visit root_path
      end

      it "displays owned lists" do
        expect(page).to have_text("Weekly groceries")
      end

      it "displays shared lists" do
        expect(page).to have_text("Dinner ingredients")
      end
    end

    describe "show" do
      it "displays buttons for owner" do
        visit shopping_list_path(shopping_list)
        expect(page).to have_css(".btn", text: I18n.t("shopping_lists.invite"))
        expect(page).to have_css(".btn", text: I18n.t("shopping_lists.manage"))
        expect(page).to have_css(".btn", text: I18n.t("shopping_lists.delete"))

        expect(page).to have_no_css(".btn", text: I18n.t("shopping_lists.leave"))
      end

      it "displays buttons for shared user" do
        visit shopping_list_path(shopping_list_2)
        expect(page).to have_no_css(".btn", text: I18n.t("shopping_lists.invite"))
        expect(page).to have_no_css(".btn", text: I18n.t("shopping_lists.manage"))
        expect(page).to have_no_css(".btn", text: I18n.t("shopping_lists.delete"))

        expect(page).to have_css(".btn", text: I18n.t("shopping_lists.leave"))
      end

      it "user can delete shopping list" do
        visit shopping_list_path(shopping_list)
        click_on "Delete"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_text("Shopping list was successfully destroyed.")
      end
    end

    describe "sharing" do
      before do
        visit shopping_list_path(shopping_list)
        click_on "Invite"
      end

      it "lets user to share his list to existing user" do
        fill_in "email", with: user_2.email
        click_on "Share"
        expect(page).to have_text("Shopping list has been shared")
      end

      it "displays shopping list users" do
        fill_in "email", with: user_2.email
        click_on "Share"
        click_on "Manage"
        expect(page).to have_text(user_2.email)
      end

      it "user can delete shopping list users" do
        fill_in "email", with: user_2.email
        click_on "Share"
        click_on "Manage"
        click_on "Remove"
        expect(page).to have_text("User successfully removed")
      end

      it "display error when sharing to non existing user" do
        fill_in "email", with: "xxx@gmail.com"
        click_on "Share"
        expect(page).to have_text("User must exist")
      end

      it "display error when sharing to same user twice" do
        fill_in "email", with: user_2.email
        click_on "Share"
        click_on "Invite"
        fill_in "email", with: user_2.email
        click_on "Share"
        expect(page).to have_text("User is already on that list")
      end

      it "doesn't display buttons to shared user" do
        visit root_path
        click_on "Dinner ingredients"
        expect(page).to have_no_css(".btn-group")
      end

      it "display error when self sharing" do
        fill_in "email", with: user.email
        click_on "Share"
        expect(page).to have_text("User is owner of the list")
      end
    end
  end

  context "when user has a list shared with multiple users" do
    let!(:shopping_list) { create(:shopping_list, name: "List1", owner: user) }

    before do
      create(:user_shopping_list, shopping_list: shopping_list)
      create(:user_shopping_list, shopping_list: shopping_list)
      visit root_path
    end

    it "displays the list once" do
      expect(page.assert_selector("span", text: shopping_list.name, count: 1)).to be true
    end
  end

  context "when user has a list shared with them" do
    let!(:shopping_list) { create(:shopping_list, :with_users, users: [user_2], owner: user) }

    before do
      sign_in user_2
      visit shopping_list_path(shopping_list)
    end

    it "lets user leave the shopping list" do
      click_on "Leave"
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_css(".alert-primary", text: I18n.t("shopping_lists.remove_self_success"))
    end
  end
end
