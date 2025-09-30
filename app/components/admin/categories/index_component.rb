class Admin::Categories::IndexComponent < ApplicationComponent
  def initialize(categories:)
    @categories = categories
  end
end
