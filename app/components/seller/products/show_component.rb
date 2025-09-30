class Seller::Products::ShowComponent < ApplicationComponent
  def initialize(product:)
    @product = product
  end
end
