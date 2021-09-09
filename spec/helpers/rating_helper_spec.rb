require "rails_helper"

RSpec.describe RatingHelper do
  describe "#rating_stars" do
    it "returns the correct values" do
      expect(helper.rating_stars(0.0, out_of: 5)).to eq([0, 0, 5])
      expect(helper.rating_stars(0.5, out_of: 5)).to eq([0, 1, 4])
      expect(helper.rating_stars(1.0, out_of: 5)).to eq([1, 0, 4])
      expect(helper.rating_stars(1.1, out_of: 5)).to eq([1, 0, 4])
      expect(helper.rating_stars(1.4, out_of: 5)).to eq([1, 1, 3])
      expect(helper.rating_stars(4.8, out_of: 5)).to eq([5, 0, 0])
      expect(helper.rating_stars(5.0, out_of: 5)).to eq([5, 0, 0])
    end
  end
end
