class UserShoppingList < ApplicationRecord
  belongs_to :user
  belongs_to :shopping_list

  validate :not_owner
  validate :already_shared

  def not_owner
    if shopping_list && shopping_list.owner == user
      errors.add(:user, I18n.t("shopping_lists.self_share"))
    end
  end

  def already_shared
    if shopping_list && shopping_list.users.include?(user)
      errors.add(:user, I18n.t("shopping_lists.already_shared"))
    end
  end
end
