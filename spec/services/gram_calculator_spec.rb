require "rails_helper"

RSpec.describe CalculatorServices::GramCalculatorService, type: :calculator_services do
  unless defined? CalculatorResults
    CalculatorResults = Struct.new(:ml, :glasses, :tablespoons, :teaspoons, :grams)
  end
  subject { CalculatorServices::GramCalculatorService }
  let!(:product) { create(:product) }
  let(:calculator_input) { CalculatorInput.new(params) }
  let(:service) { subject.new(calculator_input) }

  describe "#call" do
    let(:params) { { label: "gram", product_id: product.id.to_s, input: "100" } }
    let(:results) { service.call }

    context "given a product_id and gram value" do
      it "returns Struct" do
        expect(results).to be_a(Struct)
      end

      it "calculates correct values" do
        # ml calcuated outside of results struct to receive value before rounding
        results_ml = params[:input].to_d / Product.find(params[:product_id]).ml_to_g_rate
        expect(results["glasses"]).to eql((results_ml * subject::ML_TO_GLASS).round(2))
        expect(results["tablespoons"]).to eql((results_ml * subject::ML_TO_TABLESPOON).round(2))
        expect(results["teaspoons"]).to eql((results_ml * subject::ML_TO_TEASPOON).round(2))
        expect(results["ml"]).to eql(results_ml.round(2))
      end
    end
  end
end
