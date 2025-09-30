class Seller::Orders::IndexComponent < ApplicationComponent
  def initialize(order_items:)
    @order_items = order_items
  end
end
