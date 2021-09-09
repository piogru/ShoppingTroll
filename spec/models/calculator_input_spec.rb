require "rails_helper"

RSpec.describe CalculatorInput do
  describe "#initialize" do
    let(:calculator_input) { CalculatorInput.new(params) }

    context "given nil params hash" do
      let(:params) { nil }

      it "raises exception" do
        expect { calculator_input }.to raise_error(ArgumentError)
      end
    end
  end

  describe "validations" do
    let!(:product) { create(:product) }
    let(:params) { { label: "glass", product_id: product.id.to_s, input: "10" } }
    let(:calculator_input) { CalculatorInput.new(params) }

    context "given product_id and input" do
      it "return no errors" do
        calculator_input.validate
        expect(calculator_input.errors[:product_id]).to_not include("can't be blank")
        expect(calculator_input.errors[:input]).to_not include("can't be blank")
        expect(calculator_input.errors[:input]).to_not include("is not a number")
      end
    end

    context "given no product_id" do
      let(:params) { { label: "glass", product_id: "", input: "10" } }

      it "returns error" do
        calculator_input.validate
        expect(calculator_input.errors[:product_id]).to include("can't be blank")
      end
    end

    context "given no input" do
      let(:params) { { label: "glass", product_id: product.id.to_s, input: "" } }
      it "returns error" do
        calculator_input.validate
        expect(calculator_input.errors[:input]).to include("can't be blank")
      end
    end

    context "given input that is not numerical" do
      let(:params) { { label: "glass", product_id: product.id.to_s, input: "asdf" } }
      it "returns error" do
        calculator_input.validate
        expect(calculator_input.errors[:input]).to include("is not a number")
      end
    end

    context "given input that is a negative number" do
      let(:params) { { label: "glass", product_id: product.id.to_s, input: "-10" } }
      it "returns error" do
        calculator_input.validate
        expect(calculator_input.errors[:input]).to include("must be greater than or equal to 0")
      end
    end

    context "given product_id that does not exist in database" do
      let(:params) { { label: "glass", product_id: "10000", input: "10" } }
      it "returns error" do
        calculator_input.validate
        expect(calculator_input.errors[:product_id]).to include("must exist in database")
      end
    end
  end
end
