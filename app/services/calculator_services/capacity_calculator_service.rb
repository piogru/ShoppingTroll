module CalculatorServices
  CalculatorResults = Struct.new(:ml, :glasses, :tablespoons, :teaspoons, :grams)

  class CapacityCalculatorService
    def self.for(label)
      case label
      when "ml", "mililiter"
        CalculatorServices::MlCalculatorService
      when "glass"
        CalculatorServices::GlassCalculatorService
      when "tablespoon", "tbsp"
        CalculatorServices::TablespoonCalculatorService
      when "teaspoon", "tsp"
        CalculatorServices::TeaspoonCalculatorService
      when "gram", "g"
        CalculatorServices::GramCalculatorService
      else
        raise "Unsupported type of label: #{label}"
      end
    end
  end
end
