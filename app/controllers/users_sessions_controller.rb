class UsersSessionsController < SecureApplicationController

  def initialize
    @systemc = 'maint'
    Rails.logger.debug("* UsersSessionsController.initialize before super - systemc:#{@systemc.to_s}")
    super
  end

  before_filter do |controller|
    # self.load_session
    logger.debug('Sessions Controller filter = '+%w{ signout }.index(params[:action]).to_s)
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
    self.clear_session
  end

  def create
    self.clear_session
    logger.debug("un/pwd = "+params.to_s)
    user = User.valid_password?(params[:user_session][:username], params[:user_session][:password] )
    if user.nil?
      logger.debug ("valid_password? returned nil = not logged in.")
      redirect_to(signin_path)
    else
      logger.debug ("valid_password? returned something = logged in.")
      @user_session.sign_in(user.username, user.password)
      session[:current_user_id] = @user_session.current_user_id
      Rails.logger.debug("* UsersSessions - create - redirect_back(users_sessions#index)")
      redirect_back(:controller => 'users_sessions', :action => 'index')
    end
    
  end

  def signout
    self.clear_session
    session[:current_user_id] = nil
  end
  
  def clear_session
    Rails.logger.debug('* UsersSessionController - clear_session')
    @user_session = UserSession.new
  end
  

end
