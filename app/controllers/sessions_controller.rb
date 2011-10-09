class SessionsController < ApplicationController

  before_filter do |controller|
    @model = User.new
  end

  def new
  end

  def create
    user = User.valid_password?(params[:session][:username], (params[:session][:password]) )
    if user.nil?
      logger.debug ("valid_password? returned nil = not logged in.")
      redirect_to(new_session_path)
      # render new
      # return
    else
      logger.debug ("valid_password? returned something = logged in.")
    end
  end

  def destroy
  end
  
  private

end
