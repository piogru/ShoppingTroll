class User < ApplicationRecord
  has_many :reviews

  has_many :user_shopping_lists, foreign_key: "user_id"
  has_many :shared_shopping_lists, through: :user_shopping_lists, source: :shopping_list

  has_many :owned_shopping_lists, class_name: "ShoppingList", foreign_key: "owner_id"

  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :nickname, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def shopping_lists
    ShoppingList.left_joins(:user_shopping_lists).where(
    "shopping_lists.owner_id = :user_id OR user_shopping_lists.user_id = :user_id", user_id: id).distinct
  end
end
