module CalculatorServices
  class TablespoonCalculatorService < CapacityService
    TABLESPOON_TO_ML = 15
    TABLESPOON_TO_GLASS = 0.06
    TABLESPOON_TO_TEASPOON = 3

    def call
      ml = @input * TABLESPOON_TO_ML
      glasses = @input * TABLESPOON_TO_GLASS
      teaspoons = @input * TABLESPOON_TO_TEASPOON
      grams = ml * @product.ml_to_g_rate.to_d
      CalculatorResults.new(ml.round(2), glasses.round(2), @input.round(2), teaspoons.round(2), grams.round(2))
    end
  end
end
