require "rails_helper"

RSpec.describe Shop, type: :model do
  let!(:category_1) { create(:category, name: "First category") }
  let!(:category_2) { create(:category, name: "Second category") }
  let!(:product_1) { create(:product, categories: [category_1, category_2]) }
  let!(:product_2) { create(:product, categories: [category_1]) }
  subject! { create(:shop, :with_products, products: [product_1, product_2]) }
  let!(:user_1) { create(:user, email: "user1@example.com") }
  let!(:user_2) { create(:user, email: "user2@example.com") }
  let!(:review_1) { create(:review, user: user_1, shop: subject, stars: 3) }
  let!(:review_2) { create(:review, user: user_2, shop: subject, stars: 4) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).
        is_at_least(3)
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:products).through(:shop_products) }
    it { is_expected.to have_many(:reviews) }
  end

  describe "methods" do
    describe "#categories" do
      it "fetches the categories" do
        expect(subject.categories).to eq([category_1, category_2])
      end
    end

    describe "#average_rating" do
      it "calculates the correct rating" do
        expect(subject.average_rating).to eq(3.5)
      end
    end
  end
end
