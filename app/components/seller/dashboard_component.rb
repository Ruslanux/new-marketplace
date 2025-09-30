class Seller::DashboardComponent < ApplicationComponent
  def initialize(products_count:, orders_count:, total_revenue:, recent_orders:)
    @products_count = products_count
    @orders_count = orders_count
    @total_revenue = total_revenue
    @recent_orders = recent_orders
  end
end
