class Admin::Categories::DiscardedComponent < ApplicationComponent
  def initialize(categories:)
    @categories = categories
  end
end
