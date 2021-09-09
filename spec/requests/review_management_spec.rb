require "rails_helper"

RSpec.describe "Review management", type: :request do
  let!(:user_1) { create(:user, email: "user1@example.com") }
  let!(:user_2) { create(:user, email: "user2@example.com") }
  let!(:admin) { create(:user, email: "admin@example.com", admin: true) }
  let!(:shop) { create(:shop) }
  let!(:review) { create(:review, user: user_1, shop: shop) }
  let(:temp_review) { create(:review, user: user_2, shop: shop) }
  let(:review_attrs) { attributes_for(:review) }

  describe "GET edit" do
    context "when the user is signed in and is the author" do
      before { sign_in user_1 }

      it "renders the Shop's page with edit form" do
        get edit_shop_review_path(shop, review)
        expect(response).to be_successful
        expect(response.body).to include(shop.name).
          and include(review.title) # Edit form
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        get edit_shop_review_path(shop, review)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the user is not the author" do
      before { sign_in user_2 }

      it "renders the Shop's page with unauthorized status" do
        get edit_shop_review_path(shop, review)
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(shop.name)
      end
    end
  end

  describe "POST create" do
    context "when the user is signed in" do
      before { sign_in user_2 }

      it "creates a Review and renders the Shop's page" do
        post shop_reviews_path(shop), params: { review: review_attrs }
          expect(response.body).
            to include(I18n.t "reviews.create.success").
            and include(review_attrs[:title])

        Review.find_by(title: review_attrs[:title]).destroy!
      end

      it "doesn't create a Review with missing fields" do
        expect { post shop_reviews_path(shop), params: { review: {} } }.
          to raise_error(ActionController::ParameterMissing)
      end
    end

    context "when a review by the current user exists for the shop" do
      before { sign_in user_1 }

      it "doesn't create the Review" do
        post shop_reviews_path(shop), params: { review: review_attrs }

        expect(response.body).to include(I18n.t "reviews.create.failure")
        expect(Review.find_by(**review_attrs)).to be_nil
      end
    end

    context "when the user is not signed in" do
      it "doesn't create the Review and redirects to the sign in page" do
        post shop_reviews_path(shop), params: { review: review_attrs }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT update" do
    context "when the user is signed in and is the author" do
      before { sign_in user_1 }

      it "updates the Review and renders the Shop's page" do
        put shop_review_path(shop, review), params: { review: review_attrs }
        expect(response.body).
          to include(shop.name).
          and include(review_attrs[:title])
      end
    end

    context "when the user is not signed in" do
      it "doesn't update the Review and redirects to the sign in page" do
        put shop_review_path(shop, review),
          params: { review: review_attrs }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the user is not the author" do
      before { sign_in user_2 }

      it "renders the Shop's page with unauthorized status" do
        put shop_review_path(shop, review),
          params: { review: review_attrs }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to_not include(review_attrs[:title])
      end
    end
  end

  describe "DELETE destroy" do
    context "when the user is signed in and is the author" do
      before { sign_in user_2 }

      it "deletes the Review and renders the Shop's page" do
        delete shop_review_path(shop, temp_review)

        expect(response.body).to include(I18n.t "reviews.destroy.success")
        expect(response.body).not_to include(temp_review.title)
        expect { temp_review.reload }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the user is signed in and is an admin" do
      before { sign_in admin }

      it "deletes the Review and renders the Shop's page" do
        delete shop_review_path(shop, temp_review)

        expect(response.body).to include(I18n.t "reviews.destroy.success")
        expect(response.body).not_to include(temp_review.title)
        expect { temp_review.reload }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the user is not signed in" do
      it "doesn't delete the Review and redirects to the sign in page" do
        delete shop_review_path(shop, review)
        expect(response).to redirect_to(new_user_session_path)
        expect { review.reload }.
          not_to raise_error
      end
    end

    context "when the user is not the author" do
      before { sign_in user_2 }

      it "doesn't delete the Review and renders the Shop's page" do
        delete shop_review_path(shop, review)

        expect(response.body).to include(review.title)
        expect { review.reload }.
          not_to raise_error
      end
    end
  end
end
