# Inherit from the most basic controller to bypass all custom logic
class HomeController < ActionController::Base
  def index
    # Render simple text directly to bypass the view system entirely
    render plain: "HomeController is working!"
  end
end
