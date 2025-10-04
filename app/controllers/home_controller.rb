class HomeController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ]

  def index
    @featured_products = Product.available.includes(:category, :user, images_attachments: :blob).limit(8)
    @categories = Category.all

    render_component(Home::IndexComponent,
      featured_products: @featured_products,
      categories: @categories,
      current_user: current_user
    )
  end
end
