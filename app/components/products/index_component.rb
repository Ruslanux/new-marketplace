class Products::IndexComponent < ApplicationComponent
  # This component now uses the corresponding .html.erb template file to render.
  # The `call` method and other HTML-generating methods have been removed.

  def initialize(products:, categories:, current_category: nil, search_query: nil)
    @products = products
    @categories = categories
    @current_category = current_category
    @search_query = search_query
  end

  # Helper methods can remain here to be used by the template.
  private

  def all_categories_link
    # Determines the CSS class based on whether a category is selected.
    css_class = @current_category.blank? ? "bg-blue-600 text-white" : "bg-gray-200 text-gray-700 hover:bg-gray-300"
    link_to("All Categories", products_path(search: @search_query), class: "px-4 py-2 rounded-lg text-sm font-medium #{css_class}")
  end

  def category_filter_link(category)
    # Determines the CSS class for a specific category link.
    css_class = @current_category == category.id.to_s ? "bg-blue-600 text-white" : "bg-gray-200 text-gray-700 hover:bg-gray-300"
    link_to(category.name, products_path(category_id: category.id, search: @search_query), class: "px-4 py-2 rounded-lg text-sm font-medium #{css_class}")
  end
end
