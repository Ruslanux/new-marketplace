class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  enum :status, { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }

  def seller_orders
    order_items.joins(:product).group("products.user_id").sum(:total_price)
  end
end
