class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :profile_picture, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :phone, with: ->(phone) { phone.to_s.gsub(/\D/, "") }
  normalizes :address, with: ->(addr) { addr.to_s.strip }

  validates :email_address, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :phone, format: { with: /\A\d{10,}\z/, message: "should be at least 10 digits" }, allow_blank: true
  validates :address, length: { minimum: 10, message: "should be at least 10 characters long" }, allow_blank: true

  enum :role, { customer: 0, seller: 1, admin: 2 }

  def full_name
    [ first_name, last_name ].compact.join(" ").presence
  end

  def cart_total
    cart_items.sum { |item| item.quantity * item.product.price }
  end

  def cart_items_count
    cart_items.sum(:quantity)
  end
end
