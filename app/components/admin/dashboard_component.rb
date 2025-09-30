class Admin::DashboardComponent < ApplicationComponent
  def initialize(users_count:, products_count:, orders_count:, total_revenue:)
    @users_count = users_count
    @products_count = products_count
    @orders_count = orders_count
    @total_revenue = total_revenue
  end

  private

  def stat_card(title, value, link_path, icon_path)
    content_tag :div, class: "bg-white rounded-lg shadow-sm p-6 flex items-center justify-between" do
      content_tag(:div) do
        content_tag(:h3, title, class: "text-sm font-medium text-gray-500 uppercase tracking-wider") +
        content_tag(:p, value.to_s, class: "text-3xl font-bold text-gray-900 mt-1") +
        helpers.link_to("View All", link_path, class: "text-sm font-medium text-blue-600 hover:text-blue-800")
      end +
      content_tag(:div, class: "bg-blue-100 text-blue-600 rounded-full p-3") do
        content_tag(:svg, class: "h-6 w-6", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
          tag.path(d: icon_path, 'stroke-linecap': "round", 'stroke-linejoin': "round", 'stroke-width': "2")
        end
      end
    end
  end
end
