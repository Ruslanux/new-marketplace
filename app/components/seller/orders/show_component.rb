class Seller::Orders::ShowComponent < ApplicationComponent
  def initialize(order:)
    @order = order
  end
end
