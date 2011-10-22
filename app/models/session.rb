class Session

  attr_accessor :username, :password
  
  
  # always initialize all current user and session form information at class initialization
  def initialize
    self.username = ''
    self.password = ''
    @cur_user_id = nil
    @cur_sign_in_time = nil
    @cur_user = User.new
  end
  
  # method to sign_in a user (per username/password passed in) to the current session
  # returns current user id if valid, else nil
  def sign_in(username, password)
    user =  User.valid_password?(username, password)
    if !user.nil?
      @cur_user_id = user.id
      @cur_sign_in_time = Time.now
      @cur_user = user
    else
      initialize
    end
    return @cur_user
  end
  
  def sign_out
    initialize
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

  #def current_user=(user)
  #  sign_in(user)
  #end
    
  #def current_user_id=(user_id)
  #  sign_in(user)
  #end
    
  def signed_in?
    validate_session_length
    ( @cur_user_id.nil? ) ? false : true
  end
  
  def signed_in_at
    validate_session_length
    @cur_sign_in_time
  end
  
  def validate_session_length
    if @cur_sign_in_time != nil && @cur_sign_in_time < 10.minutes.ago
      self.initialize
    end
  end
  
  def current_sign_in_time
    @cur_sign_in_time
  end
  
  

end
