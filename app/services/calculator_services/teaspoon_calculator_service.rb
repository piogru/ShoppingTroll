module CalculatorServices
  class TeaspoonCalculatorService < CapacityService
    TEASPOON_TO_ML = 5
    TEASPOON_TO_GLASS = 0.02
    TEASPOON_TO_TABLESPOON = 0.3333

    def call
      ml = @input * TEASPOON_TO_ML
      glasses = @input * TEASPOON_TO_GLASS
      tablespoons = @input * TEASPOON_TO_TABLESPOON
      grams = ml * @product.ml_to_g_rate.to_d
      CalculatorResults.new(ml.round(2), glasses.round(2), tablespoons.round(2), @input.round(2), grams.round(2))
    end
  end
end
