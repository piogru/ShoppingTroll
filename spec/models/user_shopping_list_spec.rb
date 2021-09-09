require "rails_helper"
RSpec.describe UserShoppingList, type: :model do
  subject(:user_shopping_list) { create(:user_shopping_list) }
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:shopping_list) }
  end
end
