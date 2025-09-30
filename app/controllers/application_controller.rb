class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery with: :exception

  private

  def render_component(component, **args)
    render component.new(**args)
  end
end
