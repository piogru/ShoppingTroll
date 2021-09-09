require "rails_helper"

RSpec.describe "Devise", type: :system, js: true do
  let!(:user) { create(:user) }

  #params for user registration
  let(:params) { { email: "user@test.pl", nickname: "name", password: "password111" } }

  before do
    driven_by :chrome_headless
  end

  describe "Login" do
    before do
      visit new_user_session_path
    end

    context "given correct account information" do
      it "redirects user to homepage and flashes notice" do
        find_field("Email").fill_in(with: user.email)
        find_field("Password").fill_in(with: "password")

        find_button("Log in").click
        expect(page).to have_css(".alert-primary", text: "Signed in successfully.")
      end
    end

    context "given invalid account information" do
      it "flashes alert" do
        find_field("Email").fill_in(with: "test@test.pl")

        find_button("Log in").click
        expect(page).to have_css(".alert-danger", text: "Invalid Email or password.")
      end
    end
  end

  describe "Registration" do
    before do
      visit new_user_registration_path
    end

    context "given correct account information" do
      it "redirects user to homepage and flashes notice" do
        find_field("Nickname").fill_in(with: params[:nickname])
        find_field("Email").fill_in(with: params[:email])
        find_field("Password").fill_in(with: params[:password])
        find_field("Password confirmation").fill_in(with: params[:password])

        find_button("Sign up").click
        expect(page).to have_css(".alert-primary", text: "Welcome! You have signed up successfully.")
      end
    end

    context "given empty form" do
      it "flashes alert" do
        find_button("Sign up").click
        expect(page).to have_css(".alert-danger", text: "Email can't be blank")
        expect(page).to have_css(".alert-danger", text: "Email is invalid")
        expect(page).to have_css(".alert-danger", text: "Nickname can't be blank")
        expect(page).to have_css(".alert-danger", text: "Password can't be blank")
      end
    end
  end

  describe "Edit account" do
    before do
      sign_in user
      visit edit_user_registration_path
    end

    context "given correct account information" do
      it "flashes notice and saves changes" do
        find_field("Nickname").fill_in(with: "change")
        find_field("Email").fill_in(with: "change@test.pl")
        find_field("Password").fill_in(with: "password1234")
        find_field("Password confirmation").fill_in(with: "password1234")
        find_field("Current password").fill_in(with: "password")

        find_button("Update").click
        expect(page).to have_css(".alert-primary", text: "Your account has been updated successfully.")
      end
    end

    context "given empty current password" do
      it "flashes notice and saves changes" do
        find_field("Nickname").fill_in(with: "change")
        find_field("Email").fill_in(with: "change@test.pl")
        find_field("Password").fill_in(with: "password1234")
        find_field("Password confirmation").fill_in(with: "password1234")

        find_button("Update").click
        expect(page).to have_css(".alert-danger", text: "Current password can't be blank")
      end
    end
  end

  describe "Log out" do
    before do
      sign_in user
      visit root_path
    end

    context "when user is logged in and tries to sign out" do
      it "redirects and flashes notice" do
        if page.has_css?(".navbar-toggler-icon", wait: 0)
          page.find(".navbar-toggler-icon").click
        end

        find_button("Sign out").click
      end
    end
  end

  describe "Cancel account" do
    before do
      sign_in user
      visit edit_user_registration_path
    end

    context "when cancellation is confirmed" do
      it "flashes notice" do
        find_button("Cancel my account").click
        a = page.driver.browser.switch_to.alert
        a.accept

        expect(page).to have_css(".alert-primary",
text: "Bye! Your account has been successfully cancelled. We hope to see you again soon.")
      end
    end
  end

end
