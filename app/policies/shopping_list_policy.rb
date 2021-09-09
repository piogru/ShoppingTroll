class ShoppingListPolicy < ApplicationPolicy
  def show?
    access?
  end

  def manage?
    owner?
  end

  def share?
    owner?
  end

  def destroy?
    owner?
  end

  def remove_user?
    owner?
  end

  def remove_self?
    shared?
  end

  def shared_access?
    shared?
  end

  private

  def owner?
    record.owner == user
  end

  def access?
    record.owner == user or record.users.include?(user)
  end

  def shared?
    !(record.owner == user) and record.users.include?(user)
  end
end
