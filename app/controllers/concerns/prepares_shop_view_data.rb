module PreparesShopViewData
  extend ActiveSupport::Concern

  private

  def prepare_shop_view_data
    @shop = Shop.find(params[:shop_id] || params[:id])
    @categories = @shop.categories
    if user_signed_in? && !@shop.reviews.find_by(user: current_user)
      @edited_review = Review.new
    end
  end
end
