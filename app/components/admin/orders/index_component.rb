class Admin::Orders::IndexComponent < ApplicationComponent
  def initialize(orders:)
    @orders = orders
  end
end
