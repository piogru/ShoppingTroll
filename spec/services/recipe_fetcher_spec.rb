require "rails_helper"
require "./spec/helpers/api_stub_helper"

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe RecipeFetcher, type: :service do
  describe "API Stubs" do
    it "Responds with success" do
      stub_recipe_api_request(1)
      response = Net::HTTP.get_response(URI("#{described_class::API_URL}1"))
      expect(response).to be_a(Net::HTTPSuccess)
    end

    it "Responds with not found" do
      stub_recipe_api_request(0)
      response = Net::HTTP.get_response(URI("#{described_class::API_URL}0"))
      expect(response).to be_a(Net::HTTPNotFound)
    end
  end

  describe "#initialize" do
    context "when given no id" do
      it "raises ArgumentError" do
        expect { RecipeFetcher.call("") }.to raise_error(ArgumentError)
        expect { RecipeFetcher.call(nil) }.to raise_error(ArgumentError)
        expect { RecipeFetcher.call() }.to raise_error(ArgumentError)
      end
    end
  end
end
