class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @products = pagy(Product.order(created_at: :desc))
  end

  def show
    @product = Product.find(params[:id])
  end
end
