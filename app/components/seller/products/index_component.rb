class Seller::Products::IndexComponent < ApplicationComponent
  def initialize(products:)
    @products = products
  end
end
