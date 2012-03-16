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
    if params["status"] == 405
      @errors << "Cannot perform this action (#{request.headers["PATH_INFO"]}) with this method (#{request.headers["REQUEST_METHOD"]}).  Is Javascript turned off?"
    end
    if !session[:errors].nil?
      errs = session[:errors]
      if errs.is_a(Array)
        errs.each do | desc |
          @errors << desc
        end
      elsif errs.is_a(Hash)
        errs.each do | key, val |
          @errors << "#{key.to_s} has an error of #{val.to_s}"
        end
      elsif errs.is_a(String)
        @errors << errs
      end
    end
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
