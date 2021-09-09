class PagesController < ApplicationController
  def index
    if user_signed_in?
      @pagy_sl, @shopping_lists = pagy(current_user.shopping_lists.order(created_at: :desc))
      render "home"
    end
  end
end
