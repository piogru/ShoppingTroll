class Review < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { maximum: 2500 }
  validates :stars, presence: true, numericality: { greater_than_or_equal_to: 1,
                                                    less_than_or_equal_to: 5, only_integer: true }
  validates :shop, uniqueness: { scope: :user }
end
