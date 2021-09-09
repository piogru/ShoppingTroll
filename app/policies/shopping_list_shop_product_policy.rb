class ShoppingListShopProductPolicy < ApplicationPolicy
  def create?
    access?
  end

  def update?
    access?
  end

  def destroy?
    access?
  end

  private

  def access?
    record.shopping_list.owner == user or record.shopping_list.users.include?(user)
  end
end
