class ShopsController < ApplicationController
  include PreparesShopViewData

  before_action :prepare_shop_view_data, only: :show
  before_action :authenticate_user!

  def index
    @shops = Shop.all
    @pagy_s, @shops = pagy(Shop.order(created_at: :desc))
  end

  def show; end
end
