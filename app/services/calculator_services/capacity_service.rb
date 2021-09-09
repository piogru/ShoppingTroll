module CalculatorServices
  class CapacityService < ApplicationService
    def initialize(calculator_input)
      @product = Product.find(calculator_input.product_id)
      @input = calculator_input.input.to_d
    end
  end
end
