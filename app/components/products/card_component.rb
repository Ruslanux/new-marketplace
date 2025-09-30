class Products::CardComponent < ApplicationComponent
  with_collection_parameter :product

  def initialize(product:)
    @product = product
  end

  private

  attr_reader :product
end
