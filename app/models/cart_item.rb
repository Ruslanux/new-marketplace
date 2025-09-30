class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :product_id }

  def total_price
    quantity * product.price
  end
end
