class Home::IndexComponent < ApplicationComponent
  def initialize(featured_products:, categories:, current_user: nil)
    @featured_products = featured_products
    @categories = categories
    @current_user = current_user
  end
end
