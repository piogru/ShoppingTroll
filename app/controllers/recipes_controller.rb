class RecipesController < ApplicationController
  before_action :authenticate_user!

  def import_form
    json = RecipeFetcher.call(params[:id])

    if json["status"] == 200
      data = json["data"]
      ingredient_mapper = IngredientMapper.new
      @default_title = data["title"]
      @ingredients = data["ingredients"].map do |i|
        ingredient_mapper.map(i.to_h.with_indifferent_access)
      end
    else
      flash[:alert] = json["message"]
      redirect_to root_path
    end
  end

  def import
    shopping_list = ShoppingList.new(
      name:  params.require(:title),
      owner: current_user
    )

    shopping_list.transaction do
      shopping_list.save!

      import_product_params.each do |params|
        shopping_list_shop_product = ShoppingListShopProduct.
          new(shopping_list: shopping_list, **params)
        shopping_list_shop_product.save!
      end
    end

    flash.notice = t "recipe_import.success"
    redirect_to shopping_list

  rescue ActiveRecord::RecordInvalid
    flash.alert = t "recipe_import.failure"
    redirect_back fallback_location: root_path
  end

  private

  def import_product_params
    params.
      fetch(:products, []).
      map { |p| p.split(":") }.
      map do |(shop_product_id, amount)|
        {
          shop_product_id: shop_product_id,
          amount:          amount
        }
      end
  end
end
