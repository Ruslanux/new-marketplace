class Product < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  default_scope -> { kept }

  scope :available, -> { where("stock_quantity > 0") }
  scope :by_category, ->(category) { where(category: category) }
  scope :search, ->(query) { where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") }

  def average_rating
    # FIXED: This now safely handles products with no reviews.
    avg = reviews.average(:rating)
    avg ? avg.round(1) : 0
  end

  def in_stock?
    stock_quantity > 0
  end

  def reduce_stock!(quantity)
    update!(stock_quantity: stock_quantity - quantity)
  end
end
