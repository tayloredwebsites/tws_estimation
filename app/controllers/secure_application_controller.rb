class SecureApplicationController < ApplicationController
  # default cross-site request forgery protection
  protect_from_forgery
	
	before_filter :authenticate_user!
	
  # rescue_from CanCan::AccessDenied do |exception|
  #   flash[:error] = "Access denied."
  #   logger.error ("**** #{self.class}.SecureApplicationController CanCan::AccessDenied - #{exception.to_s}") if LOGGING
  #   logger.debug ("**** #{exception.action} - #{exception.subject.inspect}") if LOGGING
  #   redirect_to root_url
  # end

	private
	
	def pre_auth_user
		logger.debug("*********************")
		logger.debug("pre_auth_user")
	end
	
	def authenticate_user
	  pre_auth_user
		logger.debug("*********************")
		logger.debug("authenticate_user")
		post_auth_user
	end
	
	def post_auth_user
		logger.debug("*********************")
		logger.debug("post_auth_user")
	end

end
