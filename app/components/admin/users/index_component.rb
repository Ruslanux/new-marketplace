class Admin::Users::IndexComponent < ApplicationComponent
  def initialize(users:)
    @users = users
  end
end
