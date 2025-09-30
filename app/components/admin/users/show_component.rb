class Admin::Users::ShowComponent < ApplicationComponent
  def initialize(user:)
    @user = user
  end
end
