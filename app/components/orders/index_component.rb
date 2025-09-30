class Orders::IndexComponent < ApplicationComponent
  attr_reader :orders

  def initialize(orders:)
    @orders = orders
  end

  private

  def call
    render(Shared::LayoutComponent.new(title: "My Orders", current_user: current_user)) do
      content_tag :div, class: "max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8" do
        header + orders_list
      end
    end
  end

  def header
    content_tag :h1, "My Orders", class: "text-3xl font-bold text-gray-900 mb-8"
  end

  def orders_list
    if orders.any?
      content_tag :div, class: "space-y-6" do
        orders.map { |order| order_card(order) }.join.html_safe +
        pagination
      end
    else
      empty_state
    end
  end

  def order_card(order)
    link_to order_path(order), class: "block" do
      content_tag :div, class: "bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow" do
        order_header(order) +
        order_items_preview(order) +
        order_footer(order)
      end
    end
  end

  def order_header(order)
    content_tag :div, class: "flex justify-between items-start mb-4" do
      content_tag(:div) do
        content_tag(:h3, "Order ##{order.id}", class: "text-lg font-semibold text-gray-900") +
        content_tag(:p, "Placed on #{order.created_at.strftime('%B %d, %Y')}", class: "text-sm text-gray-600")
      end +
      status_badge(order.status)
    end
  end

  def status_classes
    {
      "pending" => "bg-yellow-100 text-yellow-800",
      "confirmed" => "bg-blue-100 text-blue-800",
      "shipped" => "bg-purple-100 text-purple-800",
      "delivered" => "bg-green-100 text-green-800",
      "cancelled" => "bg-red-100 text-red-800"
    }
  end

  def status_badge(status)
    content_tag(:span, status.capitalize,
                class: "px-2 inline-flex text-xs leading-5 font-semibold rounded-full #{status_classes[status]}")
  end

  def order_items_preview(order)
    content_tag :div, class: "mb-4" do
      content_tag(:p, "#{pluralize(order.order_items.count, 'item')}", class: "text-sm text-gray-600")
    end
  end

  def order_footer(order)
    content_tag :div, class: "flex justify-between items-center" do
      content_tag(:span, "Total: #{number_to_currency(order.total_amount)}",
                  class: "text-lg font-semibold text-gray-900") +
      content_tag(:span, "View Details →", class: "text-blue-600 hover:text-blue-800")
    end
  end

  def empty_state
    content_tag :div, class: "text-center py-12" do
      content_tag(:h2, "No orders yet", class: "text-2xl font-semibold text-gray-900 mb-4") +
      content_tag(:p, "When you place orders, they'll appear here.", class: "text-gray-600 mb-8") +
      link_to("Start Shopping", products_path,
              class: "bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors")
    end
  end

  def pagination
    content_tag :div, class: "flex justify-center mt-8" do
      paginate orders if respond_to?(:paginate)
    end
  end
end
