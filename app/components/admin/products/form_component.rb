class Admin::Products::FormComponent < ApplicationComponent
  def initialize(product:)
    @product = product
  end
end
