class Sessions::NewComponent < ApplicationComponent
  def initialize(error: nil)
    @error = error
  end
end
