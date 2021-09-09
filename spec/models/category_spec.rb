require "rails_helper"

RSpec.describe Category, type: :model do
  subject { build(:category) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).
        is_at_least(3)
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:products).through(:product_categories) }
  end
end
