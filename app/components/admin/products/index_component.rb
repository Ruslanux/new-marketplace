class Admin::Products::IndexComponent < ApplicationComponent
  def initialize(products:)
    @products = products
  end
end
