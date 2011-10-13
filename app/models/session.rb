class Session

  attr_accessor :username, :password
  
  
  def initialize
    self.username = ''
    self.password = ''
    @current_user_id = nil
    @current_sign_in_time = nil
    @current_user = User.new
  end
  
  def sign_in(username, password)
    user =  User.valid_password?(username, password)
    if !user.nil?
      @current_user_id = user.id
      @current_sign_in_time = Time.now
      @current_user = user
    else
      initialize
    end
    return @current_user_id
  end
  
  def sign_out
    @current_user_id = nil
    @current_sign_in_time = nil
  end
  
  def current_user
   @current_user
  end

  def current_user_id
    validate_session_length
    @current_user_id
  end

  def current_user_full_name
    validate_session_length
    @current_user.full_name
  end

  #def current_user=(user)
  #  sign_in(user)
  #end
    
  #def current_user_id=(user_id)
  #  sign_in(user)
  #end
    
  def signed_in?
    validate_session_length
    ( @current_user_id.nil? ) ? false : true
  end
  
  def signed_in_at
    validate_session_length
    @current_sign_in_time if !@current_sign_in_time.nil?
  end
  
  private
  
  def validate_session_length
    if @current_sign_in_time != nil && @current_sign_in_time < SESSION_TIMEOUT
      logger.debug ('set sign in time to nil:'+@current_sign_in_time.to_s)
      @current_sign_in_time = nil 
    end
  end
  
  

end
