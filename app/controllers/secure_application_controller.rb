class SecureApplicationController < ApplicationController
  # default cross-site request forgery protection
  protect_from_forgery

  
  # before_filter :load_session, :except => []
  # after_filter :save_session, :except => []
  # 
  # before_filter :authenticate_user
	
	
	protected
	
	def authenticate_user
		logger.debug("* SecureApplicationController -  authenticate_user")
		logger.debug('signed_in? = '+@user_session.signed_in?.to_s)
		logger.debug('current_user_id = '+@user_session.current_user_id.to_s)
    unless @user_session.signed_in?
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
