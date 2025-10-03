class HomeController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ]

  def index
    @featured_products = [] # Use an empty array instead of querying the DB
    @categories = []      # Use an empty array instead of querying the DB

    # render_component(Home::IndexComponent,
    #  featured_products: @featured_products,
    #  categories: @categories,
    #  current_user: current_user
    # )
  end
end
