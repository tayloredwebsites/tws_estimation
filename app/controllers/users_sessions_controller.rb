class UsersSessionsController < SecureApplicationController

  def initialize
    @systemc = 'guest'
    Rails.logger.debug("* UsersSessionsController.initialize before super - systemc:#{@systemc.to_s}")
    super
  end

  before_filter do |controller|
    # self.load_session
    logger.debug('* UsersSessionsController.before_filter = '+%w{ signout }.index(params[:action]).to_s)
    self.authenticate_user if !(%w{ signout }.index(params[:action]).nil?)
    @model = User.new
    @errors = Array.new
  end
    
  # skip_filter :authenticate_user, :only => [:signin, :create]
  #   
  # before_filter do |controller|
  #   @model = User.new
  # end
  # 
  # def initialize
  #   logger.debug('initialize')
  #   # self.clear_session
  #   super
  # end
  # 
  def signin
    # self.clear_session
  end

  def create
    # self.clear_session
    #Rails.logger.debug("* UsersSessionsController.create params = "+params.to_s)
    @user_session.sign_in(params[:user_session][:username], params[:user_session][:password])
    #Rails.logger.debug("* UsersSessionController.create @user_session = #{@user_session.inspect.to_s}")
    #Rails.logger.debug("* UsersSessionController.create session = #{session.inspect.to_s}")
    @user_session.errors.each do |attr, msg|
      # Rails.logger.debug("* UsersSessionController.create error:#{msg}")
      notify_error(msg)
    end
    # Rails.logger.debug("* UsersSessionController.create @user_session.signed_in?:#{@user_session.signed_in?}")
    if @user_session.signed_in?
      Rails.logger.debug("* UsersSessionsController.create - redirect_back(users_sessions#index)")
      redirect_back(:controller => 'users_sessions', :action => 'index')
    else
      redirect_to(signin_path)
    end
    
  end

  def signout
    self.clear_session
    session[:current_user_id] = nil
    Rails.logger.debug("* UserSessionsController.signout to render signout")
    render :action => 'signout'
  end
  
  def clear_session
    Rails.logger.debug('* UsersSessionController - clear_session')
    #@user_session = UserSession.new
    @user_session.sign_out
  end
  

end
