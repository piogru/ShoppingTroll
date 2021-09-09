require "rails_helper"

RSpec.describe ShoppingListsController, type: :request do
  let!(:owner) { create(:user, email: "test1@example.com") }
  let!(:user_1) { create(:user, email: "test2@example.com") }
  let!(:user_2) { create(:user, email: "test3@example.com") }

  let!(:products) { 6.times.collect { create(:product) } }
  let!(:shop_1) { create(:shop, :with_products, products: products.values_at(4, 2, 0)) }
  let!(:shop_2) { create(:shop, :with_products, products: products.values_at(1, 5, 3, 4)) }

  let!(:shopping_list) {
    create(
      :shopping_list,
      :with_users, :with_shop_products,
      owner:         owner,
      users:         [user_1],
      shop_products: products.
        map { |product| product.shop_products.first }
    )
  }

  describe "GET shopping list" do
    context "when the owner is signed in" do
      before { sign_in owner }

      it "renders the shopping list page" do
        get shopping_list_path(shopping_list)
        expect(response).to be_successful
        expect(response.body).to include(shopping_list.name)
      end

      it "includes all products once and in the correct order" do
        get shopping_list_path(shopping_list)
        expect(
          response.body.
            scan(/class="product-name.*?(Product #\d+)/m)
        ).to eq shopping_list.shop_products.
          sort_by { |sp| [sp.shop_id, sp.id] }.
          map { |sp| [sp.product.name] }
      end
    end

    context "when an authorized user is signed in" do
      before { sign_in user_1 }

      it "renders the shopping list page" do
        get shopping_list_path(shopping_list)
        expect(response).to be_successful
        expect(response.body).to include(shopping_list.name)
      end

      it "displays error when trying to delete shopping list as shared user" do
        delete shopping_list_path(shopping_list)
        follow_redirect!
        expect(response.body).to include I18n.t("pundit.not_authorized")
      end

      it "displays error when trying to share shopping list as shared user" do
        post share_shopping_list_path(shopping_list), params: { email: user_2.email }
        follow_redirect!
        expect(response.body).to include I18n.t("pundit.not_authorized")
      end

      it "displays error when trying to share shopping list as shared user" do
        delete remove_user_shopping_list_path(shopping_list), params: { user_id: user_2.id }
        follow_redirect!
        expect(response.body).to include I18n.t("pundit.not_authorized")
      end
    end

    context "when a non-authorized user is signed in" do
      before { sign_in user_2 }

      it "redirects to the sign in page" do
        get shopping_list_path(shopping_list)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        get shopping_list_path(shopping_list)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET new shopping list" do
    before { sign_in owner }

    it "renders new shopping list form" do
      get new_shopping_list_path
      expect(response).to be_successful
    end
  end

  describe "POST shopping list" do
    it "create shopping list for current user" do
      sign_in user_1
      post shopping_lists_path, params: { shopping_list: { name: "my list" } }
      expect(ShoppingList.last.name).to eq "my list"
    end

    it "doesn't create shopping list if the user is not signed in" do
      post shopping_lists_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "doesn't allow to create shopping list with missing params" do
      sign_in user_1
      expect { post shopping_lists_path, params: {} }.
        to raise_error(ActionController::ParameterMissing)
    end
  end

  describe "POST share shopping list" do
    before { sign_in owner }

    context "when another's user email is already used" do
      it "renders error" do
        post "/shopping_lists/#{shopping_list.id}/share", params: { email: user_1.email }
        expect(response).to redirect_to(shopping_list_path(shopping_list.id))
        follow_redirect!
        expect(response.body).to include I18n.t("shopping_lists.already_shared")
      end
    end

    context "when another's user email is same as owner" do
      it "renders error" do
        post "/shopping_lists/#{shopping_list.id}/share", params: { email: owner.email }
        expect(response).to redirect_to(shopping_list_path(shopping_list.id))
        follow_redirect!
        expect(response.body).to include I18n.t("shopping_lists.self_share")
      end
    end

    context "when another's user email is valid" do
      it "lets share user's shopping list with user_2" do
        post "/shopping_lists/#{shopping_list.id}/share", params: { email: user_2.email }
        expect(user_2.shared_shopping_lists.count).to eq(1)
      end
    end
  end

  describe "DELETE #remove_self" do
    context "when user is signed in as owner" do
      before do
        sign_in owner
      end

      it "flashes unauthorized alert" do
        delete remove_self_shopping_list_path(shopping_list)
        expect(flash[:alert]).to eq(I18n.t("pundit.not_authorized"))
      end
    end

    context "when user is not signed in" do
      it "redirects to login page" do
        delete remove_self_shopping_list_path(shopping_list)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is signed in as shared to user" do
      before do
        sign_in user_1
      end

      it "removes user and flashes notice" do
        delete remove_self_shopping_list_path(shopping_list)
        expect(flash[:notice]).to eq(I18n.t("shopping_lists.remove_self_success"))
        expect(user_2.shared_shopping_lists.count).to eq(0)
      end
    end
  end
end
