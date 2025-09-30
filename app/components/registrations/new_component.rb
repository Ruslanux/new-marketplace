class Registrations::NewComponent < ApplicationComponent
  def initialize(user:)
    @user = user
  end
end
