class ShoppingListShopProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_product, only: %i(edit destroy update)

  def new
    @shopping_list_shop_product = ShoppingListShopProduct.new(shop_product_id: params[:shop_product_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    if ShoppingListShopProduct.exists?(
        shopping_list_id: shopping_list_shop_product_params[:shopping_list_id],
        shop_product_id:  shopping_list_shop_product_params[:shop_product_id])
      increment_amount
      return
    end
    @shopping_list_shop_product = ShoppingListShopProduct.new(shopping_list_shop_product_params)
    authorize @shopping_list_shop_product unless @shopping_list_shop_product.shopping_list.nil?
    if @shopping_list_shop_product.save
      flash.now[:notice] = t "shopping_list.add_success"
      respond_to do |format|
        format.js { render partial: "shopping_list_shop_products/success" }
      end
    else
      respond_to do |format|
        format.js { render :new }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    authorize @shopping_list_shop_product
    if @shopping_list_shop_product.update(shopping_list_shop_product_params)
      @shopping_list = @shopping_list_shop_product.shopping_list
      flash.now[:notice] = t "shopping_list.edit_success"
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render :edit }
      end
    end
  end

  def destroy
    authorize @shopping_list_shop_product
    @shopping_list = @shopping_list_shop_product.shopping_list
    @shopping_list_shop_product.destroy
    flash.now[:notice] = t "shopping_list.delete_success"
    respond_to do |format|
      format.js
    end
  end

  def increment_amount
    @shopping_list_shop_product = ShoppingListShopProduct.
      find_by!(
           shopping_list_id: shopping_list_shop_product_params[:shopping_list_id],
           shop_product_id:  shopping_list_shop_product_params[:shop_product_id]
      )
    authorize @shopping_list_shop_product
    @shopping_list_shop_product.update!(
      amount: @shopping_list_shop_product.amount + shopping_list_shop_product_params[:amount].to_i)
    flash.now[:notice] = t("shopping_list.increase_success", new_amount: @shopping_list_shop_product.amount)
    respond_to do |format|
      format.js { render partial: "shopping_list_shop_products/success" }
    end
  end

  private

  def fetch_product
    @shopping_list_shop_product = ShoppingListShopProduct.find(params[:id])
  end

  def shopping_list_shop_product_params
    params.require(:shopping_list_shop_product).permit(:bought, :shop_product_id, :shopping_list_id, :amount)
  end
end
