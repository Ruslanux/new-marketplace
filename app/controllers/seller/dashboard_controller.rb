class Seller::DashboardController < ApplicationController
  def index
    @products_count = current_user.products.count
    @orders_count = OrderItem.joins(:product).where(products: { user: current_user }).count
    @total_revenue = OrderItem.joins(:product).where(products: { user: current_user }).sum(:total_price)
    @recent_orders = OrderItem.joins(:product, :order)
                             .where(products: { user: current_user })
                             .includes(:order, :product)
                             .limit(5)

    render_component(Seller::DashboardComponent,
      products_count: @products_count,
      orders_count: @orders_count,
      total_revenue: @total_revenue,
      recent_orders: @recent_orders
    )
  end
end
