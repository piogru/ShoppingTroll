class ShoppingListsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_shopping_list, only: %i(show remove_user remove_self share destroy)

  def new
    @shopping_list = current_user.owned_shopping_lists.new
  end

  def show; end

  def create
    @shopping_list = current_user.owned_shopping_lists.create(shopping_list_params)
    if @shopping_list.errors.any?
      flash[:alert] = @shopping_list.errors.full_messages
      redirect_back(fallback_location: root_path)
    else
      flash[:notice] = t("shopping_lists.created")
      redirect_to shopping_list_path(@shopping_list)
    end
  end

  def share
    user = User.find_by(email: params[:email])
    user_list = UserShoppingList.create(user: user, shopping_list: @shopping_list)
    if user_list.errors.any?
      flash[:alert] = user_list.errors.full_messages
    else
      flash[:notice] = t("shopping_lists.share_success")
    end
    redirect_to shopping_list_path(@shopping_list)
  end

  def remove_user
    if (UserShoppingList.find_by(shopping_list_id: params[:id], user_id: params[:user_id]).destroy!)
      flash[:notice] = t("shopping_lists.user_removed")
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = t("shopping_lists.remove_user_error")
      redirect_back(fallback_location: root_path)
    end
  end

  def remove_self
    if (UserShoppingList.find_by(shopping_list_id: params[:id], user_id: current_user.id).destroy!)
      flash[:notice] = t("shopping_lists.remove_self_success")
      redirect_to root_path
    else
      flash[:alert] = t("shopping_lists.remove_self_error")
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @shopping_list.destroy!
    flash[:notice] = t("shopping_lists.destroy_success")
    redirect_to root_path
  end

  private

  def shopping_list_params
    params.require(:shopping_list).permit(:name)
  end

  def authorize_shopping_list
    @shopping_list = ShoppingList.find(params[:id])
    authorize @shopping_list
  end
end
