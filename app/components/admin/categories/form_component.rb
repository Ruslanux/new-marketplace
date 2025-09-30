class Admin::Categories::FormComponent < ApplicationComponent
  def initialize(category:)
    @category = category
  end
end
