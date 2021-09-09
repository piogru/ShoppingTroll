class ReviewsController < ApplicationController
  include PreparesShopViewData

  before_action :authenticate_user!, except: %i(index show)
  before_action :prepare_shop_view_data
  before_action :fetch_review, only: %i(edit update destroy)
  before_action :require_owner!, only: %i(edit update)
  before_action(only: :destroy) { require_owner! allow_admin: true }

  def index
    render "shops/show"
  end

  def show
    render "shops/show"
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    if @review.save
      flash.now.notice = t ".success"
      @edited_review = nil
    else
      flash.now.alert = t ".failure"
      @edited_review = @review
    end

    render "shops/show"
  end

  def edit
    @edited_review = @review
    render "shops/show"
  end

  def update
    if @review.update(review_params)
      flash.now.notice = t ".success"
      @edited_review = nil
    else
      flash.now.alert = t ".failure"
      @edited_review = @review
    end
    render "shops/show"
  end

  def destroy
    if @review.destroy
      flash.now.notice = t ".success"
      @edited_review = Review.new
    else
      flash.now.alert = t ".failure"
    end
    render "shops/show"
  end

  private

  def fetch_review
    @review = @shop.reviews.find(params[:id])
  end

  def review_params
    params.
      require(:review).
      permit(:stars, :title, :description).
      merge(shop_id: params.require(:shop_id))
  end

  def require_owner!(allow_admin: false)
    unless current_user == @review.user || (allow_admin && current_user&.admin?)
      render "shops/show", status: :unauthorized
    end
  end
end
