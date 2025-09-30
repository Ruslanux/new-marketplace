class Seller::Shared::LayoutComponent < ApplicationComponent
  attr_reader :title

  def initialize(title:)
    @title = title
  end

  # This public method is now accessible by the component's template.
  def seller_nav_link(text, path)
    active = request.path.starts_with?(path)
    # Handle the dashboard root path edge case
    active = true if request.path == seller_root_path && path == seller_root_path

    base_classes = "flex items-center px-4 py-2 rounded-md text-sm font-medium transition-colors"
    active_classes = "bg-gray-900 text-white"
    inactive_classes = "text-gray-300 hover:bg-gray-700 hover:text-white"
    classes = active ? "#{base_classes} #{active_classes}" : "#{base_classes} #{inactive_classes}"

    helpers.link_to text, path, class: classes
  end
end
