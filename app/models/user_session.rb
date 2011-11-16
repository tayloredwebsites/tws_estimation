class UserSession
  
  include ActiveModel::Validations  # to give standard errors

  attr_accessor :username, :password

  
  # Override the initialize to handle hashes of named parameters
  # http://stackoverflow.com/questions/5407940/named-parameters-in-ruby-structs
  # changed instance_of? to is_a? because session inherits from Hash (is not an instance of Hash)
  def initialize *args
    if args.length == 0
      # ok - no errors, create empty session
      self.init
    elsif args.length > 1
      errors.add(:base, I18n.translate('errors.invalid_method_argument', :method => 'user_session', :argument => '# args') )
      self.init
    elsif !args.first.is_a?(Hash)
      errors.add(:base, I18n.translate('errors.invalid_method_argument', :method => 'user_session', :argument => '!is_a? Hash') )
      self.init
    else
      @app_session = args.first
      self.load_user_session
    end
    super
  end

  def init
    Rails.logger.debug('* UserSession - init')
    @sign_in_time = nil
    # self.username = ''
    Rails.logger.debug('* UserSession - init - call sign_out')
    self.sign_out
  end
  
  def sign_out
    Rails.logger.debug('* UserSession - sign_out')
    @time_last_accessed = nil
    # self.password = ''
    # @cur_user_id = nil
    @cur_user = User.guest
    @cur_user_id = 0
    # Rails.logger.debug('UserSession @cur_user: id='+@cur_user.id.to_s+', username='+@cur_user.username.to_s)
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
    @sign_in_time = @app_session[:sign_in_time]
    @time_last_accessed = @app_session[:time_last_accessed]
    @cur_user_id = @app_session[:current_user_id]
    if @cur_user_id.nil? || @cur_user_id == 0 || @time_last_accessed.nil?
      Rails.logger.debug('* UserSession - build_user_session - call sign_out')
      self.sign_out
    else
      @cur_user = User.find_by_id(@cur_user_id)
    end
    validate_session_length
  end
  
  def save_user_session
  end
  
  def get_app_session
    @app_session
  end

  # method to sign_in a user (per username/password passed in) to the current session
  # returns current user_session
  def sign_in(username, password)
    user =  User.valid_password?(username, password)
    if !user.nil?
      Rails.logger.debug('* UserSession - sign_in - valid username:'+username.to_s+', password:'+password.to_s)
      @sign_in_time = Time.now
      @time_last_accessed = @sign_in_time
      @cur_user_id = user.id
      @cur_user = user
    else
      Rails.logger.debug('* UserSession - sign_in - not a valid username:'+username.to_s+', password:'+password.to_s)
      init
    end
    return self
  end
  
  def current_user
    validate_session_length
    @cur_user
  end

  def current_user_id
    validate_session_length
    @cur_user_id
  end

  def current_user_full_name
    validate_session_length
    @cur_user.full_name
  end
  
  def time_last_accessed
    validate_session_length
    @time_last_accessed
  end

  def signed_in?
    validate_session_length
    ( @cur_user_id.nil? || @cur_user_id == 0 ) ? false : true
  end
  
  def validate_session_length
    if @time_last_accessed != nil && @time_last_accessed < SESSION_TIMEOUT_SECONDS.seconds.ago
      Rails.logger.debug('time last accessed = '+@time_last_accessed.to_s)
      Rails.logger.debug('SESSION_TIMEOUT_SECONDS.seconds.ago = '+SESSION_TIMEOUT_SECONDS.seconds.ago.to_s )
      Rails.logger.debug('* UserSession - validate_session_length - call sign_out')
      self.sign_out
    end
    (@time_last_accessed.nil?) ? false : true
  end
  
  def expire_user_session
    @time_last_accessed = SESSION_TIMEOUT_SECONDS.seconds.ago
  end
  
end
