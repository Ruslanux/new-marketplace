class ApplicationComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Turbo::StreamsHelper

  private

  def current_user
    helpers.current_user if helpers.respond_to?(:current_user)
  end
end
