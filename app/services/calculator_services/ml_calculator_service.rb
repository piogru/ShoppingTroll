module CalculatorServices
  class MlCalculatorService < CapacityService
    ML_TO_GLASS = 0.004
    ML_TO_TABLESPOON = 0.6667
    ML_TO_TEASPOON = 0.2

    def call
      glasses = @input * ML_TO_GLASS
      tablespoons = @input * ML_TO_TABLESPOON
      teaspoons = @input * ML_TO_TEASPOON
      grams = @input * @product.ml_to_g_rate.to_d
      CalculatorResults.new(@input.round(2), glasses.round(2), tablespoons.round(2), teaspoons.round(2), grams.round(2))
    end
  end
end
