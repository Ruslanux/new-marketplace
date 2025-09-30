class Seller::Products::FormComponent < ApplicationComponent
  def initialize(product:, categories:)
    @product = product
    @categories = categories
  end
end
