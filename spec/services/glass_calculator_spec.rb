require "rails_helper"

RSpec.describe CalculatorServices::GlassCalculatorService do
  unless defined? CalculatorResults
    CalculatorResults = Struct.new(:ml, :glasses, :tablespoons, :teaspoons, :grams)
  end
  subject { CalculatorServices::GlassCalculatorService }
  let!(:product) { create(:product) }
  let(:calculator_input) { CalculatorInput.new(params) }
  let(:service) { subject.new(calculator_input) }

  describe "#call" do
    let(:params) { { label: "glass", product_id: product.id.to_s, input: "5" } }
    let(:results) { service.call }

    context "given a product_id and glass amount" do
      it "returns Struct" do
        expect(results).to be_a(Struct)
      end

      it "calculates correct values" do
        input = params[:input].to_d
        expect(results["ml"]).to eql((input * subject::GLASS_TO_ML).round(2))
        expect(results["tablespoons"]).to eql((input * subject::GLASS_TO_TABLESPOON).round(2))
        expect(results["teaspoons"]).to eql((input * subject::GLASS_TO_TEASPOON).round(2))
        expect(results["grams"]).to eql((results["ml"] * Product.find(params[:product_id]).ml_to_g_rate).round(2))
      end
    end
  end
end
