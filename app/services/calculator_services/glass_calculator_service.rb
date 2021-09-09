module CalculatorServices
  class GlassCalculatorService < CapacityService
    GLASS_TO_ML = 250
    GLASS_TO_TABLESPOON = 16.6667
    GLASS_TO_TEASPOON = 50

    def call
      ml = @input * GLASS_TO_ML
      tablespoons = @input * GLASS_TO_TABLESPOON
      teaspoons = @input * GLASS_TO_TEASPOON
      grams = ml * @product.ml_to_g_rate.to_d
      CalculatorResults.new(ml.round(2), @input.round(2), tablespoons.round(2), teaspoons.round(2), grams.round(2))
    end
  end
end
