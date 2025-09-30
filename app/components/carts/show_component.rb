class Carts::ShowComponent < ApplicationComponent
  def initialize(cart_items:)
    @cart_items = cart_items
  end

  def cart_total
    @cart_items.sum(&:total_price)
  end
end
