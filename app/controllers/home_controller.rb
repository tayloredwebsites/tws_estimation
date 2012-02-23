class HomeController < SecureApplicationController
  
  def initialize
    # Home controller will be the guest system controller.
    @systemc = 'guest'
    Rails.logger.debug("* UsersController.initialize before super - systemc:#{@systemc.to_s}")
    super
  end
	
  before_filter do |controller|
    # self.load_session
    # logger.debug('Home Controller filter = '+%w{ site_map }.index(params[:action]).to_s)
    self.authenticate_user if !(%w{ site_map }.index(params[:action]).nil?)
    @model = User.new
    @errors = Array.new
  end
    
  def about
  end

  def contact
  end

  def errors
  end

  def help
  end

  def index
  end

  def news
  end

  def site_map
  end

  def status
  end

end
