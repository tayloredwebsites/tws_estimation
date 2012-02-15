class ApplicationController < ActionController::Base
  protect_from_forgery
	layout "application"
  
  include ApplicationHelper
  include Application::CommonMethods
  
  before_filter :load_user_session
  after_filter :save_user_session
  
  def initialize
    @systemc = 'home' if @systemc.blank? # default system
    #Rails.logger.debug("* ApplicationController.initialize before super - systemc:#{@systemc.to_s}")
    super
    @user_session = UserSession.new
    @errors = Array.new
    @guest_ability = Ability.new(User.guest)
    self.load_user_session if (!@_request.nil? && !session.nil?)
    #Rails.logger.debug("* ApplicationController.initialize done")
  end
  
  def load_user_session
    #Rails.logger.debug("* ApplicationController.load_user_session start")
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
    if @user_session.signed_in?
      logger.debug("* ApplicationController - load_user_session - #{current_user.full_name}Signed in!")
    else
      logger.debug('* ApplicationController - load_user_session - Not signed in!')
    end
    show_deact = params[:show_deactivated]
    Rails.logger.debug("* ApplicationController.load_user_session params[:show_deactivated]:#{show_deact}")
    if !show_deact.nil?
      if db_value_true?(show_deact)
        show_deactivated
      else
        dont_show_deactivated
      end
      Rails.logger.debug(("* ApplicationController.load_user_session params[:show_deactivated]:#{params[:show_deactivated]} => #{show_deactivated?}"))
    #else
    #  dont_show_deactivated
    #  Rails.logger.debug(("* ApplicationController.load_user_session initialized params[:show_deactivated]:#{params[:show_deactivated]} => #{show_deactivated?}"))
    end
  end

  def save_user_session
    @user_session.get_session_info.each do |key, value|
      #Rails.logger.debug("* ApplicationController.save_user_session #{key}: #{value.inspect.to_s}")
      session[key] = value;
    end
    session[:time_last_accessed] = Time.now
    #Rails.logger.debug ("* ApplicationController - save_user_session - time_last_accessed = #{session[:time_last_accessed].to_s}")
    #Rails.logger.debug ("* ApplicationController.save_user_session user session saved:  "+@user_session.inspect.to_s)
    (@user_session.signed_in?) ?
      Rails.logger.debug('* ApplicationController - save_user_session - Signed in!') :
      Rails.logger.debug('* ApplicationController - save_user_session - Signed out!')
    #Rails.logger.debug("* ApplicationController.save_user_session - session: #{session.inspect.to_s}") 
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
    #Rails.logger.debug "* ApplicationController.rescue_from CanCan::AccessDenied on #{exception.action} #{exception.subject.inspect}"
    if !params.nil?
      Rails.logger.warn("* ApplicationController.rescue_from CanCan::AccessDenied - params:#{params.inspect.to_s}")
    end
    notify_error(I18n.translate('errors.access_denied_msg', :method => params[:action], :obj => params[:controller].pluralize))
    # Rails.logger.debug("* ApplicationController.rescue_from CanCan::AccessDenied - guest can do this?:#{@guest_ability.can?(params[:action].to_sym, User.guest)}")
    if @user_session.signed_in?
      # if signed in already, go directly to error for this user.
      redirect_to(home_errors_path)
    else
      # Not Signed in
      if @guest_ability.can?(params[:action].to_sym, User.guest)
        # When is this code ever used ????
        Rails.logger.debug("* ApplicationController.rescue_from CanCan::AccessDenied - guest can do this!!, don't make them signin. How did we get here?")
        redirect_to(home_errors_path)
      else
        # if not signed in, and must be signed in to do this, force the user to sign in
        # redirect_to('/signin')
        # Rails.logger.debug("* ApplicationController.rescue_from CanCan::AccessDenied - redirect_away users_sessions#signin")
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
    Rails.logger.debug("* ApplicationController.redirect_away - original uri:#{request.fullpath}, to:#{params.inspect.to_s}")
    req_method = request.request_method()
    Rails.logger.debug("* ApplicationController.redirect_away - req_method:#{req_method}")
    if req_method.upcase == 'GET'
      session[:original_uri] = request.fullpath()
      @user_session.set_info(:original_uri, request.fullpath())
      redirect_to(*params)
    else
      Rails.logger.warn("* ApplicationController.redirect_away - not a GET, cannot redirect, goes to home")
      notify_warning("Sorry, will not be able to redirect back to GET #{request.fullpath}")
      session[:original_uri] = home_index_path
      @user_session.set_info(:original_uri, home_index_path)
      redirect_to(*params)
    end
  end

  # returns the person to either the original url from a redirect_away or to a default url
  # http://ethilien.net/archives/better-redirects-in-rails/
  def redirect_back(*params)
    Rails.logger.debug("* ApplicationController.redirect_back - params:#{params.inspect.to_s}")
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
