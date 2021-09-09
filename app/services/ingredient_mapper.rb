class IngredientMapper < ApplicationService
  # Computes shop product suggestions for an ingredient (hash with keys: `:name`, `:quantity`, `:unit`)
  # and puts them under the key `:suggestions`.
  # Each entry in the `:suggestions` array is a hash with the following fields:
  #  * `:shop_product` - the suggested `ShopProduct`
  #  * `:quantity` - the minimum required integer quantity of the product matching the ingredient's `:quantity`
  def map(ingredient)
    unless %i(name quantity unit).all? { |key| ingredient.key? key }
      raise ArgumentError, "invalid ingredient hash"
    end

    ingredient.merge(
      suggestions: ShopProduct.
        matching(ingredient[:name]).
        order(price: :asc).
        map do |shop_product|
          {
            shop_product: shop_product,
            quantity:     calculate_quantity(
                            shop_product.product_id,
                            ingredient[:quantity],
                            ingredient[:unit],
                            shop_product.product.capacity,
                            shop_product.product.label
                          )
          }
        end
    )
  end

  # Calculates the minimum required integer quantity of a product based on
  # the required quantity of an ingredient.
  def calculate_quantity(
    product_id,
    ingredient_quantity,
    ingredient_unit,
    product_capacity,
    product_unit
  )
    required_ml = CalculatorServices::CapacityCalculatorService.
      for(ingredient_unit).
      call(CalculatorInput.new(
        product_id: product_id,
        input:      ingredient_quantity
      ))[:ml]

    capacity_ml = CalculatorServices::CapacityCalculatorService.
      for(product_unit).
      call(CalculatorInput.new(
        product_id: product_id,
        input:      product_capacity
      ))[:ml]

    (required_ml / capacity_ml).ceil
  end
end
