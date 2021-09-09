require "rails_helper"

RSpec.describe CapacityController, type: :request do
  let!(:product) { create(:product) }

  describe "#calculate_capacity" do
    context "when results received" do
      it "should render js" do
        get calculate_capacity_path, xhr: true, params: {
          label:      "ml",
          product_id: Product.first.id,
          input:      "500"
        }
        expect(response).to be_successful
      end
    end

    context "when label is not present" do
      it "should flash alert" do
        get calculate_capacity_path, xhr: true, params: {
          label:      "",
          product_id: product.id.to_s,
          input:      "500"
        }
        expect(flash[:alert]).to eq("Please select label and product")
      end
    end

    context "when product_id is not present" do
      it "should flash alert" do
        get calculate_capacity_path, xhr: true, params: {
          label:      "ml",
          product_id: "",
          input:      "500"
        }
        expect(flash[:alert]).to eq("Please select label and product")
      end
    end

    context "when product_id does not exist in database" do
      it "should raise exception" do
        expect { get calculate_capacity_path, xhr: true, params: {
          label:      "ml",
          product_id: "1000",
          input:      "500"
          }
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context "when input is not present" do
      it "should flash alert" do
        get calculate_capacity_path, xhr: true, params: {
          label:      "ml",
          product_id: product.id.to_s,
          input:      ""
        }
        expect(flash[:alert]).to eq("Please enter value to convert")
      end
    end
  end

  describe "#calculate_form" do
    context "when results received" do
      it "should render js" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "mold",
          recipe_form_x: "12",
          recipe_form_y: "12",
          home_form:     "mold",
          home_form_x:   "15",
          home_form_y:   "15"
        }
        expect(response).to be_successful
      end
    end

    context "when a recipe form type is not selected" do
      it "should flash alert" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "",
          recipe_form_x: "12",
          recipe_form_y: "12",
          home_form:     "mold",
          home_form_x:   "15",
          home_form_y:   "15"
        }
        expect(flash[:alert]).to eq("Please select form types")
      end
    end

    context "when home form type is not present" do
      it "should flash alert" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "mold",
          recipe_form_x: "12",
          recipe_form_y: "12",
          home_form:     "",
          home_form_x:   "15",
          home_form_y:   "15"
        }
        expect(flash[:alert]).to eq("Please select form types")
      end
    end

    context "when recipe form type is mold and y dimension is not present" do
      it "should flash alert" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "mold",
          recipe_form_x: "12",
          recipe_form_y: "",
          home_form:     "mold",
          home_form_x:   "15",
          home_form_y:   "15"
        }
        expect(flash[:alert]).to eq("Please input form dimensions")
      end
    end

    context "when recipe form type is mold and y dimension is not present" do
      it "should flash alert" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "mold",
          recipe_form_x: "12",
          recipe_form_y: "12",
          home_form:     "mold",
          home_form_x:   "15",
          home_form_y:   ""
        }
        expect(flash[:alert]).to eq("Please input form dimensions")
      end
    end

    context "when a form's x dimension is missing" do
      it "should flash alert" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "caketin",
          recipe_form_x: "",
          recipe_form_y: "",
          home_form:     "mold",
          home_form_x:   "15",
          home_form_y:   "15"
        }
        expect(flash[:alert]).to eq("Please input form dimensions")
      end

      it "should flash alert" do
        get calculate_form_path, xhr: true, params: {
          recipe_form:   "mold",
          recipe_form_x: "12",
          recipe_form_y: "12",
          home_form:     "caketin",
          home_form_x:   "",
          home_form_y:   ""
        }
        expect(flash[:alert]).to eq("Please input form dimensions")
      end
    end
  end
end
