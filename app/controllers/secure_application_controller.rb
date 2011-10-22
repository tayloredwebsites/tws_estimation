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
		logger.debug('signed_in? = '+@session.signed_in?.to_s)
		logger.debug('current_user_id.nil? = '+@session.current_user_id.nil?.to_s)
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
