class HomeController < ApplicationController
  before_filter do |controller|
    @model = User.new
    @errors = Array.new
  end
    
  def index
  end

  def help
  end

end
