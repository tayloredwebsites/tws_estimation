class HomeController < SecureApplicationController

  # 
  # after_filter :save_session
  # 
	
  before_filter do |controller|
    # self.load_session
    # logger.debug('Home Controller filter = '+%w{ site_map }.index(params[:action]).to_s)
    self.authenticate_user if !(%w{ site_map }.index(params[:action]).nil?)
    @model = User.new
    @errors = Array.new
  end
    
  def index
  end

  def help
  end
  
  def site_map
  end

end
