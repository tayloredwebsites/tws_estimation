class UserSession
  
  include ActiveModel::Validations  # to give standard errors

  attr_accessor :username, :password

  
  # Override the initialize to handle hashes of named parameters
  # http://stackoverflow.com/questions/5407940/named-parameters-in-ruby-structs
  # changed instance_of? to is_a? because session inherits from Hash (is not an instance of Hash)
  def initialize *args
    #Rails.logger.debug ("* UserSession.initialize")
    if args.length == 0
      # ok - no errors, create empty session
      self.init
    elsif args.length > 1
      Rails.logger.error("*Error UserSession.initialize num args > 1")
      errors.add(:base, I18n.translate('errors.invalid_method_argument', :method => 'user_session', :argument => '# args') )
      self.init
    elsif !args.first.is_a?(Hash)
      Rails.logger.error("*Error UserSession.initialize first arg is a hash")
      errors.add(:base, I18n.translate('errors.invalid_method_argument', :method => 'user_session', :argument => '!is_a? Hash') )
      self.init
    else
      @app_session = args.first
      Rails.logger.debug("* UserSession.initialize one arg - @app_session: #{@app_session.inspect.to_s}")
      self.load_user_session
    end
    super *args
    #Rails.logger.debug ("* UserSession.initialize done")
  end

  def init
    #Rails.logger.debug('* UserSession.init')
    @session_info = Hash.new()
    @sign_in_time = nil
    @cur_user_id = 0
    @cur_user = nil
    #Rails.logger.debug('* UserSession.init done')
  end
  
  def sign_out
    # Rails.logger.debug('* UserSession - sign_out')
    @time_last_accessed = nil
    @cur_user = User.guest
    @cur_user_id = 0
    return @cur_user
  end
  
  def load_user_session
    if !@app_session.nil?
      self.build_user_session
      validate_session_length
    else
      self.init
    end
  end
  
  def build_user_session
    @session_info = Hash.new()
    SESSION_INFO_DEFAULTS.each do |key, value|
      set_info(key,value)
      # Rails.logger.debug("* UserSession.build_user_session default @session_info: #{key}: #{value.inspect.to_s}")
    end
    # Rails.logger.debug("* UserSession.build_user_session @app_session:#{@app_session.inspect.to_s}")
    @sign_in_time = @app_session[:sign_in_time]
    @time_last_accessed = @app_session[:time_last_accessed]
    @cur_user_id = @app_session[:current_user_id]
    if !@cur_user_id.nil? && !@cur_user_id == 0
    else 
      # Rails.logger.debug("* UserSession.build_user_session find_by_id:#{@cur_user_id}")
      @cur_user = User.find_by_id(@cur_user_id)
    end
    if @cur_user.nil?
      self.sign_out  # sign in as guest!!
    else
      # Rails.logger.debug("* UserSession.build_user_session found @cur_user:#{@cur_user.inspect.to_s}")
      self.validate_session_length
    end
    @app_session.each do |key, value|
      # Rails.logger.debug("* UserSession.build_user_session #{key}: #{value.inspect.to_s}")
      set_info(key,value)
      # @session_info[key.to_s] = value;
    end
  end
  
  def info(key)
    @session_info[key.to_sym]
  end
  
  def set_info(key,value)
    if !(VALID_SESSION_INFO.index(key.to_s).nil?)
      # Rails.logger.debug("* UserSession.set_info key,value:#{key.inspect.to_s}/#{value.inspect.to_s}")
      @session_info[key.to_sym]=value
    else
      Rails.logger.warn("* UserSession.set_info - attempt to set session variable to invalid key: #{key.to_s}")
      # Rails.logger.debug("* UserSession.set_info - VALID_SESSION_INFO: #{VALID_SESSION_INFO}")
      # Rails.logger.debug("* UserSession.set_info - VALID_SESSION_INFO.index(#{key}).nil?: #{VALID_SESSION_INFO.index(key.to_s).nil?}")
    end
  end
  
  def save_user_session
  end
  
  def get_session_info
    set_info('sign_in_time', @sign_in_time)
    set_info('time_last_accessed', @time_last_accessed)
    set_info('current_user_id', ( (@cur_user == nil) ? 0 : @cur_user.id ) )
    # Rails.logger.debug("* UserSession.get_session_info @session_info:#{@session_info.inspect.to_s}")
    @session_info
  end

  # method to sign_in a user (per username/password passed in) to the current session
  # returns current user_session
  def sign_in(username, password)
    # Rails.logger.debug('* UserSession.sign_in -username:'+username.to_s+', password:'+password.to_s)
    user =  User.valid_password?(username, password)
    if user.nil?
      # Rails.logger.debug('* UserSession.sign_in - not a valid username:'+username.to_s+', password:'+password.to_s)
      init
    elsif user.deactivated?
      # Rails.logger.debug('* UserSession.sign_in - valid sign_in - deactivated user:'+user.inspect.to_s)
      init
      errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'login', :msg => I18n.translate('error_messages.you_are_deactivated') ) )
    elsif user.errors.size > 0
      # Rails.logger.debug("* UserSession.signin - errors:#{errors.inspect.to_s}")
      user.errors.each do |attr, msg|
        errors.add(:base, msg)
      end
    else
      @sign_in_time = Time.now
      @time_last_accessed = @sign_in_time
      @cur_user_id = user.id
      @cur_user = user
      # Rails.logger.debug('* UserSession.sign_in - valid sign_in - user:'+user.inspect.to_s)
    end
    # Rails.logger.debug('* UserSession.sign_in - self:'+self.inspect.to_s)
    return self
  end
  
  def current_user
    # validate_session_length
    @cur_user
  end

  def current_user_id
    validate_session_length
    # @cur_user_id
    ( @cur_user == nil) ? 0 : @cur_user.id
  end

  def current_user_full_name
    validate_session_length
    ( @cur_user == nil) ? '' : @cur_user.full_name
  end
  
  def time_last_accessed
    validate_session_length
    @time_last_accessed
  end

  def signed_in?
    # Rails.logger.debug("* UserSession.signed_in? - self: #{self.inspect.to_s}")
    validate_session_length if (!@cur_user.nil? && @cur_user.id != 0)
    # ( @cur_user_id.nil? || @cur_user_id == 0 ) ? false : true
    ( @cur_user.nil? || @cur_user.id.nil? || @cur_user.id == 0 ) ? false : true
    
  end
  
  def validate_session_length
    #R ails.logger.debug("* UserSession.validate_session_length - self: #{self.inspect.to_s}")
    if @time_last_accessed != nil && @time_last_accessed < SESSION_TIMEOUT_SECONDS.seconds.ago
      # Rails.logger.debug('* UserSession - validate_session_length - time last accessed = '+@time_last_accessed.to_s)
      # Rails.logger.debug('* UserSession - validate_session_length - SESSION_TIMEOUT_SECONDS.seconds.ago = '+SESSION_TIMEOUT_SECONDS.seconds.ago.to_s )
      # Rails.logger.debug('* UserSession - validate_session_length - call sign_out')
      self.sign_out
    end
    (@time_last_accessed.nil?) ? false : true
  end
  
  def expire_user_session
    @time_last_accessed = SESSION_TIMEOUT_SECONDS.seconds.ago
  end
  
end
