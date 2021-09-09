module CalculatorServices
  class GramCalculatorService < CapacityService
    ML_TO_GLASS = 0.004
    ML_TO_TABLESPOON = 0.6667
    ML_TO_TEASPOON = 0.2

    def call
      ml = @input / @product.ml_to_g_rate.to_d
      glasses = ml * ML_TO_GLASS
      tablespoons = ml * ML_TO_TABLESPOON
      teaspoons = ml * ML_TO_TEASPOON
      CalculatorResults.new(ml.round(2), glasses.round(2), tablespoons.round(2), teaspoons.round(2), @input.round(2))
    end
  end
end
