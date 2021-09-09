require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).
        is_at_least(3)
    end
    it { is_expected.to validate_presence_of(:capacity) }
    it { is_expected.to validate_numericality_of(:capacity).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_presence_of(:ml_to_g_rate) }
    it { is_expected.to validate_numericality_of(:ml_to_g_rate).is_greater_than(0) }
  end

  describe "associations" do
    it { is_expected.to have_many(:categories).through(:product_categories) }
    it { is_expected.to have_many(:shops).through(:shop_products) }
  end

  describe "scopes" do
    describe "matching" do
      let!(:product_1) { create(:product, name: "Good water") }
      let!(:product_2) { create(:product, name: "Nice water") }
      let!(:product_3) { create(:product, name: "Nice salt") }

      it "returns the correct products" do
        expect(Product.matching("water")).
          to include(product_1, product_2).
          and not_include(product_3)
      end
    end
  end
end
