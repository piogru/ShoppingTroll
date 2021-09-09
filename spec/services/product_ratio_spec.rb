require "rails_helper"

RSpec.describe CalculatorServices::ProductRatioService do
  subject { CalculatorServices::ProductRatioService }

  describe "#initialize" do
    let(:service) { subject.new(params) }

    context "given nil params hash" do
      let(:params) { nil }

      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given no recipe form type" do
      let(:params) { { recipe_form: "", recipe_form_x: "10", home_form: "mold",
          home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given no home form type" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given no recipe form x dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "", home_form: "mold",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given no home form x dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "mold",
        home_form_x: "", recipe_form_y: "10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given mold recipe form type and no y dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given mold home form type and no y dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given negative recipe form x dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "-10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given negative recipe form y dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "-10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given negative home form x dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "-10", home_form: "mold",
        home_form_x: "-20", recipe_form_y: "10", home_form_y: "20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end

    context "given negative home form y dimension" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "-10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "-20" } }
      it "raises exception" do
        expect { service }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#call" do
    context "given mold types and dimensions" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      let(:result) { subject.call(params) }
      it "returns Decimal" do
        expect(result).to be_a(BigDecimal)
      end
    end

    context "given 2 mold form types and dimensions" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "mold",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      let(:service) { subject.new(params) }
      let(:result) { service.call }

      it "returns correct values" do
        recipe = 10.to_d**2
        home = 20.to_d**2
        ratio = (home / recipe).round(2)
        expect(result).to eql(ratio)
      end
    end

    context "given mold and cake tin form types and dimensions" do
      let(:params) { { recipe_form: "mold", recipe_form_x: "10", home_form: "caketin",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      let(:service) { subject.new(params) }
      let(:result) { service.call }

      it "returns correct values" do
        recipe = 10.to_d * 10.to_d
        home = 20.to_d**2 * Math::PI
        ratio = (home / recipe).round(2)
        expect(result).to eql(ratio)
      end
    end

    context "given 2 cake tin form types and dimensions" do
      let(:params) { { recipe_form: "caketin", recipe_form_x: "10", home_form: "caketin",
        home_form_x: "20", recipe_form_y: "10", home_form_y: "20" } }
      let(:service) { subject.new(params) }
      let(:result) { service.call }

      it "returns correct values" do
        recipe = 10.to_d**2 * Math::PI
        home = 20.to_d**2 * Math::PI
        ratio = (home / recipe).round(2)
        expect(result).to eql(ratio)
      end
    end
  end
end
