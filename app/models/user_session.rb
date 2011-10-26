class UserSession

  attr_accessor :username, :password
  
  # Override the initialize to handle hashes of named parameters
  # http://stackoverflow.com/questions/5407940/named-parameters-in-ruby-structs
  # changed instance_of? to is_a? because session inherits from Hash (is not an instance of Hash)
  def initialize *args
    if (args.length == 1 && args.first.is_a?(Hash) )    # && !args.first[:current_user_id].nil?)
      #args.first.each_pair do |k, v|
      #  self[k] = v if members.map {|x| x.intern}.include? k
      #end
      @session = args.first
      self.load_user_session
    else
      # super
      self.init
    end
  end

  def init
    self.username = ''
    @sign_in_time = nil
    self.sign_out
  end
  
  def sign_out
    self.password = ''
    @time_last_accessed = nil
    @cur_user_id = nil
    @cur_user = User.new
  end
  
  def load_user_session
    if !@session.nil?
      self.build_user_session
    else
      self.init
    end
  end
  
  def build_user_session
    @sign_in_time = @session[:sign_in_time]
    @time_last_accessed = @session[:time_last_accessed].nil?
    @cur_user_id = @session[:current_user_id]
    @cur_user = (@cur_user_id.nil?) ? nil : User.find_by_id(@cur_user_id)
  end
  
  def save_user_session
  end

  # method to sign_in a user (per username/password passed in) to the current session
  # returns current user_session
  def sign_in(username, password)
    user =  User.valid_password?(username, password)
    if !user.nil?
      @sign_in_time = Time.now
      @time_last_accessed = @sign_in_time
      @cur_user_id = user.id
      @cur_user = user
    else
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

  def signed_in?
    validate_session_length
    ( @cur_user_id.nil? ) ? false : true
  end
  
  def validate_session_length
    if @sign_in_time != nil && @sign_in_time < 30.seconds.ago
      self.sign_out
    end
    (@sign_in_time.nil?) ? false : true
  end
  
  
  def user_session_expired
    lambda{10.minutes.ago}
  end
  def user_session_expires_in
    lambda{10.minutes}
  end
  
end
