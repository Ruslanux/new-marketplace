class Orders::ShowComponent < ApplicationComponent
  attr_reader :order

  def initialize(order:)
    @order = order
  end

  private

  def call
    render(Shared::LayoutComponent.new(title: "Order ##{order.id}", current_user: current_user)) do
      content_tag :div, class: "max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8" do
        order_header + order_items + order_summary
      end
    end
  end

  def order_header
    content_tag :div, class: "bg-white rounded-lg shadow-md p-6 mb-8" do
      content_tag(:div, class: "flex justify-between items-start mb-4") do
        content_tag(:div) do
          content_tag(:h1, "Order ##{order.id}", class: "text-2xl font-bold text-gray-900") +
          content_tag(:p, "Placed on #{order.created_at.strftime('%B %d, %Y at %I:%M %p')}",
                      class: "text-gray-600")
        end +
        status_badge(order.status)
      end +
      content_tag(:p, "Total: #{number_to_currency(order.total_amount)}",
                  class: "text-xl font-semibold text-blue-600")
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

  def order_items
    content_tag :div, class: "bg-white rounded-lg shadow-md overflow-hidden mb-8" do
      content_tag(:h2, "Order Items", class: "text-lg font-semibold text-gray-900 p-6 border-b") +
      content_tag(:div) do
        order.order_items.map { |item| order_item_row(item) }.join.html_safe
      end
    end
  end

  def order_item_row(item)
    content_tag :div, class: "flex items-center p-6 border-b border-gray-200 last:border-b-0" do
      item_image(item.product) +
      item_details(item) +
      item_pricing(item)
    end
  end

  def item_image(product)
    content_tag :div, class: "w-20 h-20 flex-shrink-0 mr-6" do
      if product.image.attached?
        image_tag product.image, class: "w-full h-full object-cover rounded-lg"
      else
        content_tag :div, class: "w-full h-full bg-gray-200 rounded-lg flex items-center justify-center" do
          content_tag(:span, "No Image", class: "text-xs text-gray-500")
        end
      end
    end
  end

  def item_details(item)
    content_tag :div, class: "flex-1 mr-6" do
      link_to product_path(item.product), class: "hover:text-blue-600" do
        content_tag(:h3, item.product.name, class: "font-semibold text-gray-900 mb-1")
      end +
      content_tag(:p, "by #{item.product.user.name}", class: "text-sm text-gray-600 mb-1") +
      content_tag(:p, "Quantity: #{item.quantity}", class: "text-sm text-gray-700")
    end
  end

  def item_pricing(item)
    content_tag :div, class: "text-right" do
      content_tag(:p, "#{number_to_currency(item.price)} each", class: "text-sm text-gray-600") +
      content_tag(:p, number_to_currency(item.total_price), class: "font-semibold text-gray-900")
    end
  end

  def order_summary
    content_tag :div, class: "bg-white rounded-lg shadow-md p-6" do
      content_tag(:h2, "Order Summary", class: "text-lg font-semibold text-gray-900 mb-4") +
      content_tag(:div, class: "space-y-2") do
        content_tag(:div, class: "flex justify-between") do
          content_tag(:span, "Subtotal:", class: "text-gray-600") +
          content_tag(:span, number_to_currency(order.total_amount), class: "font-semibold")
        end +
        content_tag(:div, class: "flex justify-between border-t pt-2") do
          content_tag(:span, "Total:", class: "text-lg font-semibold") +
          content_tag(:span, number_to_currency(order.total_amount), class: "text-lg font-bold text-blue-600")
        end
      end
    end
  end
end
