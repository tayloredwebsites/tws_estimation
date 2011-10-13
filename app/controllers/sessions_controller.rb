class SessionsController < SecureApplicationController

	
	skip_before_filter :authenticate_user, :only => [:signin, :create]
	
  before_filter do |controller|
    @model = User.new
  end
  
  def initialize
    logger.debug('initialize')
    self.clear_session
    super
  end

  def signin
  end

  def create
    self.clear_session
    user = User.valid_password?(params[:session][:username], (params[:session][:password]) )
    if user.nil?
      logger.debug ("valid_password? returned nil = not logged in.")
      redirect_to(signin_path)
    else
      logger.debug ("valid_password? returned something = logged in.")
      @session.sign_in(user.username, user.password)
    end
  end

  def signout
    self.clear_session
  end
  
  def clear_session
    @session = Session.new
  end
  

end
