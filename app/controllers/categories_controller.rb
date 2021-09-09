class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy_c, @categories = pagy(Category.order(created_at: :desc))
  end

  def show
    @category = Category.find(params[:id])
    @pagy, @products = pagy(@category.products)
  end

end
