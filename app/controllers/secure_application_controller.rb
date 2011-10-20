class SecureApplicationController < ApplicationController
  # default cross-site request forgery protection
  protect_from_forgery

  
  # before_filter :load_session, :except => []
  # after_filter :save_session, :except => []
  # 
  # before_filter :authenticate_user
	
	
	protected
	
	def authenticate_user
		logger.debug("*** authenticate_user")
    unless @session.signed_in?
      notify_error ("You must be logged in to access this section")
      redirect_to(signin_path) # halts request cycle
    end
  end
  
  # 
  # def authorize_user
  #   logger.debug("*** authorize_user")
  # end
  # 
end
