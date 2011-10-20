class SessionsController < SecureApplicationController
  #   
  # after_filter :save_session
  #   
  before_filter do |controller|
    # self.load_session
    # logger.debug('Sessions Controller filter = '+%w{ signout }.index(params[:action]).to_s)
    # self.authenticate_user if !(%w{ site_map }.index(params[:action]).nil?)
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
