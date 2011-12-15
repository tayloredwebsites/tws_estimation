class ApplicationController < ActionController::Base
  protect_from_forgery
	layout "application"
  
  include ApplicationHelper
  
  before_filter :load_user_session
  after_filter :save_user_session
  
  def initialize
    Rails.logger.debug("* ApplicationController.initialize before super - systemc:#{@systemc.to_s}")
    super
    @user_session = UserSession.new
    @errors = Array.new
    @guest_ability = Ability.new(User.guest)
  end
  
  def load_user_session
    #logger.debug ("session = "+session.inspect) if !session.nil?
    @user_session = UserSession.new (session)
    if @user_session.errors.count > 0
      notify_error("!!! ApplicationController - load_user_session - Error restoring session")
      @user_session.errors.each do |attr, msg|
        logger.error("!!! ApplicationController - load_user_session - Session error: "+msg)
      end
      # redirect_to('/home/errors')
      @user_session.errors.clear
      # redirect_to('/signin')
    end
    #logger.debug ("* user session created:  "+@user_session.inspect)
    (@user_session.signed_in?) ? logger.debug("* ApplicationController - load_user_session - #{current_user.full_name}Signed in!") : logger.debug('* ApplicationController - load_user_session - Signed out!') 
    Rails.logger.debug("* ApplicationController - load_user_session - params=#{params.inspect.to_s}")
  end

  def save_user_session
    @user_session.save_user_session 
    session[:current_user_id] = @user_session.current_user_id
    session[:time_last_accessed] = Time.now
    logger.debug ("* ApplicationController - save_user_session - time_last_accessed = #{session[:time_last_accessed].to_s}")
    #logger.debug ("* user session saved:  "+@user_session.inspect)
    (@user_session.signed_in?) ? logger.debug('* ApplicationController - save_user_session - Signed in!') : logger.debug('* ApplicationController - save_user_session - Signed out!') 
  end
  
  def current_user  # needed for cancan
    @user_session.current_user
  end

  # # cancan - ability initialization with session available
  # # https://github.com/ryanb/cancan/issues/133
  # def current_ability
  #   @current_ability ||= Ability.new(@user_session.current_user)  #(current_user, session)
  # end

  # cancan - global rescue from access denied - sends to errors page.
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    if !params.nil?
      Rails.logger.debug("* ApplicationController - rescue_from CanCan:: - params:#{params.inspect.to_s}")
    end
    notify_error(I18n.translate('errors.access_denied_msg', :msg => exception.message))
    Rails.logger.debug("* ApplicationController - rescue_from CanCan:: - guest can do this?:#{@guest_ability.can?(params[:action].to_sym, User.guest)}")
    if @user_session.signed_in?
      redirect_to(home_errors_path)
    else
      if @guest_ability.can?(params[:action].to_sym, User.guest)
        Rails.logger.debug("* ApplicationController - rescue_from CanCan:: - guest can do this!!, don't make them signin.")
        redirect_to(home_errors_path)
      else
        # redirect_to('/signin')
        Rails.logger.debug("* ApplicationController - rescue_from CanCan - redirect_away users_sessions#signin")
        redirect_away(:controller => 'users_sessions', :action => 'signin')
      end
    end
  end
  
  rescue_from ActiveRecord::ActiveRecordError do |exception|
    notify_error(I18n.translate('errors.active_record_error_msg', :msg => exception.message))
    redirect_to(home_errors_path)
  end
  

  # redirect somewhere that will eventually return back to here
  # http://ethilien.net/archives/better-redirects-in-rails/
  def redirect_away(*params)
    session[:original_uri] = request.fullpath
    Rails.logger.debug("* ApplicationController - redirect_away - original uri:#{request.request_uri}, to:#{params.inspect.to_s}")
    redirect_to(*params)
  end

  # returns the person to either the original url from a redirect_away or to a default url
  # http://ethilien.net/archives/better-redirects-in-rails/
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri
      Rails.logger.debug("* ApplicationController - redirect_to uri:#{uri}")
      redirect_to uri
    else
      Rails.logger.debug("* ApplicationController - redirect_to params:#{params.inspect.to_s}")
      redirect_to(*params)
    end
  end
  
  def notify_error (message)
    logger.error(message)
    user_notify(message)
  end
  
  def notify_warning (message)
    logger.warn(message)
    user_notify(message)
  end
  
  def notify_success (message)
    logger.info(message)
    user_notify(message)
  end
  
  def user_notify(message)
    flash[:notice] = message
    @errors.push(message)
  end

end
