class Admin::DashboardController < ApplicationController
  def index
    @users_count = User.count
    @products_count = Product.count
    @orders_count = Order.count
    @total_revenue = Order.sum(:total_amount)

    render_component(Admin::DashboardComponent,
      users_count: @users_count,
      products_count: @products_count,
      orders_count: @orders_count,
      total_revenue: @total_revenue
    )
  end
end
