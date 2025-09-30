class Seller::Products::DiscardedComponent < ApplicationComponent
  def initialize(products:)
    @products = products
  end
end
