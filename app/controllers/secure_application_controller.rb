class SecureApplicationController < ApplicationController
  # default cross-site request forgery protection
  protect_from_forgery

  
  # before_filter :load_session, :except => []
  # after_filter :save_session, :except => []
  # 
  # before_filter :authenticate_user
	
	
	protected
	
	def authenticate_user
		#Rails.logger.debug("* SecureApplicationController -  authenticate_user")
		Rails.logger.debug('* SecureApplicationController - authenticate_user - signed_in? = '+@user_session.signed_in?.to_s)
		#Rails.logger.debug('* SecureApplicationController - authenticate_user - current_user_id = '+@user_session.current_user_id.to_s)
    unless @user_session.signed_in?
      notify_error ("You must be logged in to access this section")
      Rails.logger.debug("* SecureApplicationController - rescue_from CanCan - redirect_away users_sessions#signin")
      redirect_away(:controller => 'users_sessions', :action => 'signin')
      # redirect_to(signin_path) # halts request cycle
    end
    Rails.logger.debug("* SecureApplicationController - authenticate_user - params=#{params.inspect.to_s}")
  end
  
  # 
  # def authorize_user
  #   logger.debug("*** authorize_user")
  # end
  # 
end
