class HomeController < ActionController::Base
  def index
    puts "--- HomeController#index was called! ---"
    render plain: "HomeController is working!"
    puts "--- HomeController#index finished! ---"
  end
end
