class Profiles::ShowComponent < ApplicationComponent
  def initialize(user:)
    @user = user
  end
end
