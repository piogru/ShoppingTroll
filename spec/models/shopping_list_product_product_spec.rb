require "rails_helper"

RSpec.describe ShoppingListShopProduct, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:amount) }
    it do
      is_expected.to validate_numericality_of(:amount).
        is_greater_than(0)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:shopping_list) }
    it { is_expected.to belong_to(:shop_product) }
  end
end
