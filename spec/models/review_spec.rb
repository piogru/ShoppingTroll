require "rails_helper"

RSpec.describe Review, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it do
      is_expected.to validate_length_of(:title).
        is_at_least(3).is_at_most(100)
    end

    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).
        is_at_most(2500)
    end

    it { is_expected.to validate_presence_of(:stars) }
    it do
      is_expected.to validate_numericality_of(:stars).only_integer.
        is_greater_than_or_equal_to(1).
        is_less_than_or_equal_to(5)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:shop) }
  end
end
