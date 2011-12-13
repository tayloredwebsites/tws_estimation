class User < ActiveRecord::Base
  
  include UserRoles
  include CommonMethods
  
  attr_accessible :first_name, :last_name, :email, :username, :deactivated, :password, :password_confirmation, :old_password, :roles
  attr_accessor :password, :old_password
  validates :username,
      :presence => true,
      :uniqueness => true
  validates :password,
      # :presence => true,
      :confirmation => true
  validates :email,
      :presence => true,
      :uniqueness => true,
      :format => {:with => Regexp.new(VALID_EMAIL_EXPR) }
   
  before_save :validate_save, :validate_assigned_roles
  
  #before_update_password :validate_password
  # after_find :load_assigned_roles
  after_find :load_deactivated
  
  scope :deactivated, where(:deactivated => DB_TRUE)
  scope :active, where(:deactivated => DB_FALSE)
  
  def initialize(*args)
    # init_user_roles([])
    super(*args)
    load_deactivated
  end
  
  def self.guest
    # logger.debug("* User - self.guest")
    @user = self.new
    @user.id = 0
    @user.username = 'Guest'
    @user.first_name = 'Guest'
    # logger.debug("* User - self.guest - about to call @user.init_user_roles([])")
    @user.roles =  DEFAULT_ROLE.join(' ')
    # logger.debug("* User - self.guest done")
    return @user
  end

  # def new(*params)
  #   Rails.logger.debug("* User - new - params #{params.inspect.to_s}")
  #   super(*params)
  # end
  # 
  # def self.create(*params)
  #   Rails.logger.debug("* User - self.create - *params #{params.inspect.to_s}")
  #   Rails.logger.debug("* User - self.create - self #{self.inspect.to_s}")
  #   super(*params)
  # end
  # 
  # def self.create!(*params)
  #   Rails.logger.debug("* User - self.create! - *params #{params.inspect.to_s}")
  #   Rails.logger.debug("* User - self.create! - self #{self.inspect.to_s}")
  #   super(*params)
  # end
  
  def create
    Rails.logger.debug("* User - create - self #{self.inspect.to_s}")
    Rails.logger.debug ("* User - create - create has errors") if !errors.empty?
    validate_password
    # Rails.logger.debug("* User - create - call validate_assigned_roles")
    validate_assigned_roles
    super if errors.empty?
  end
  
  def save
    # logger.debug("* User - save")
    Rails.logger.debug ("save has errors:#{errors.inspect.to_s}") if !errors.empty?
    self.validate_password
    self.validate_assigned_roles
    super if errors.empty? && self.id != 0
  end
  
  # method to delete a record, only if it is already deactivated
  def delete
  	if active?
      # errors.add(:deactivated, "cannot delete active record")
			errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'delete', :msg => I18n.translate('error_messages.is_active') ) )
			errors.add(:deactivated, I18n.translate('error_messages.is_active') )
			return false
  	end
  	if errors.empty?
			super # call parent to delete record
  	end
  end

  # method to destroy a record, only if it is already deactivated
  def destroy
    # Rails.logger.debug("* User - destroy - deactivated.nil? = #{self.deactivated.nil?}")
    # Rails.logger.debug("* User - destroy - deactivated = #{self.deactivated.to_s}")
  	if active?
  	  Rails.logger.debug("* User - destroy - cannot destroy active user")
      # errors.add(:deactivated, "cannot destroy active record")
			errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'destroy', :msg => I18n.translate('error_messages.is_active') ) )
			errors.add(:deactivated, I18n.translate('error_messages.is_active') )
			return false
			#raise "Error - cannot destroy active record"
  	end
  	if errors.empty?
			super # call parent to destroy record
  	end
  end


  # method to deactivate record
  def deactivate
  	if deactivated?
		  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') ) )
			errors.add(:deactivated, I18n.translate('error_messages.is_deactivated') )
			return false
  	else
			self.deactivated = DB_TRUE;
			if !self.save
			  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.got_error') ) )
			  errors.add(:deactivated, I18n.translate('error_messages.got_error') )
			  return false
			end
  	end
  	return true
  end

  # method to reactivate record
  def reactivate
  	if deactivated?
			self.deactivated = DB_FALSE;
			if !self.save
			  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.got_error') ) )
			  errors.add(:deactivated, I18n.translate('error_messages.got_error') )
			  return false
			end
  	else
		  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') ) )
			errors.add(:deactivated, I18n.translate('error_messages.is_active') )
			return false
  	end
    return true
  end
  
  def deactivated?
    if self.deactivated == DB_TRUE
      return true
    elsif self.deactivated == DB_FALSE
      return false
    else
      Rails.logger.error("*Error User - invalid value for deactivated:#{self.deactivated.to_s}")
      return load_deactivated
    end
  end
  
  def reactivated?
    return !deactivated?
  end
  
  def active?
    return !deactivated?
  end

  # class level valid_password to check password against user in database
  def self.valid_password? (username, password, password_confirmation=nil)
    auth_user = find_by_username(username) if !username.nil?
    if auth_user.nil?
      Rails.logger.debug('* User.valid_password? - username not found')
      return nil
    else
      # Rails.logger.debug('* User.valid_password? - username matched:'+auth_user.username.to_s)
      auth_user.password = auth_user.password_confirmation = password
      auth_user.password_confirmation = password_confirmation if !password_confirmation.nil?
      auth_user.validate_password
      # Rails.logger.debug('* User.valid_password? - auth_user.errors.count='+auth_user.errors.count.to_s)
      return (auth_user.errors.count == 0 ? auth_user : nil)
    end
  end
  
  # instance level password check against current user
  def has_password? (password_in, password_confirmation=nil)
    if !password_confirmation.nil? && password_in != password_confirmation
      false
    elsif self.encrypted_password != encrypt(password_in)
      false
    else
      true
    end
  end


  # validate password fields and place errors into active model errors
  # good for create or udpate
  def validate_password
    if self.new_record?
      errors.add(:password, I18n.translate('error_messages.missing_password') ) if self.password.blank?
    end
    if !self.password.blank?
      if self.password != self.password_confirmation
        errors.add(:password_confirmation, I18n.translate('error_messages.password_mismatch') )
      else
        errors.add(:password, I18n.translate('error_messages.invalid_password') ) if !self.new_record? && !has_matching_password?
      end
    end
  end
  
  # value parameter should be the roles string
  def validate_roles(value)
    Rails.logger.debug("* User - validate_roles - roles:#{value.inspect.to_s}")
    init_user_roles(value)
    Rails.logger.debug("* User - validate_roles - roles after init_user_roles - value:#{value.inspect.to_s}")
    Rails.logger.debug("* User - validate_roles - roles after init_user_roles - self.roles:#{self.roles.inspect.to_s}")
    self.roles = validate_assigned_roles
  end
  
  def can_field_be_edited?(field_name, current_user)
    # if current_user is not this user, then OK
    return true if current_user.id.to_s != self.id.to_s
    # if not one of the no self update fields, then OK
    return true if USER_SELF_NO_UPDATE_FIELDS.index(field_name).nil?
    # if current_user has one of the self update roles, then OK
    return true if (current_user.roles.split(' ') & USER_SELF_UPDATE_ROLES).size > 0
    # otherwise return false
    return false
  end
  
  def update_attributes(params)
    # Rails.logger.debug("* User - update_attributes - params=#{params.inspect.to_s}")
	  Rails.logger.error("* UserRoles - update_attributes - roles is an array !!!") if params[:roles].instance_of?(Array)
    if valid_password_change?(params)
      # valid password change, set it
      self.password = params[:password]
      self.password_confirmation = params[:password_confirmation]
      params.delete(:old_password)
      encrypt_password
    else
      # not a valid password change, clear them out
      params.delete(:old_password)
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    if !params[:roles].nil?
      params[:roles]=validate_roles(params[:roles])
    end
    # Rails.logger.debug("* User - update_attributes - call to super(#{params.inspect.to_s})")
    super(params)
  end
  
  def update_attribute(name,value)
    # do not allow password change through update_attribute
	  Rails.logger.error("* UserRoles - update_attribute - roles is an array !!!") if name.to_s == 'roles' && value.instance_of?(Array)
    if %w{password password_confirmation old_password}.index(name).nil?
      if name.to_s == 'roles'
        # Rails.logger.debug("* User - update_attributes - initial roles:#{value.inspect.to_s}")
        new_values = validate_roles(value)
        super(name,new_values) # update db with validated roles
        # Rails.logger.debug("* User - update_attributes - updated roles:#{value.inspect.to_s}")
      else
        # not password or roles, so update
        super(name,value)
      end
    else
      errors.add(:password, I18n.translate('error_messages.password_mismatch') )
    end
  end
  
  
  def valid_password_change?(params)
    if params[:old_password].blank?
      # cannot be a password change if there is no old password
      false
    elsif params[:password].blank?
      false
    elsif params[:password] != params[:password_confirmation]
      errors.add(:password_confirmation, I18n.translate('error_messages.password_mismatch') )
      false
    elsif self.encrypted_password != encrypt(params[:old_password])
      errors.add(:password_confirmation, I18n.translate('error_messages.invalid_password') )
      errors.add(:password, I18n.translate('error_messages.invalid_password') ) 
      false
    else
      true
    end
  end
  
  def reset_password
    self.password = generate_password
    self.password_confirmation = self.password
    encrypt_password
  end
  
  
  
  def full_name
    name = ''
    name += self.first_name if !self.first_name.nil?
    name += ' ' + self.last_name if !self.last_name.nil?
    return name
  end
  
  
  private
 
  # validation before save method is called !!
  # if passing in password, validate it before save (validate if password is not blank)
  def validate_save
    self.validate_password
    encrypt_password if errors.count == 0
  end
    
  # see if password passed in matches the encryped password
  def has_matching_password?
    if self.password.blank? || self.encrypted_password.blank?
      false
    elsif self.old_password.nil?
      # match current password against encrypted password
      self.encrypted_password == encrypt(self.password)
    else
      # match old password against encrypted password (for password change)
      self.encrypted_password == encrypt(self.old_password)
    end
  end
  
  def encrypt_password
    self.password_salt = generate_salt if self.new_record?
    self.encrypted_password = encrypt(self.password) if !self.password.blank?
  end
  def generate_salt
    encrypt_hash("#{Time.now.utc}--#{self.password}")
  end
  def encrypt(string)
    encrypt_hash("#{self.password_salt}--#{string}")
  end
  def encrypt_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  def generate_password
    encrypt_hash("#{Time.now.utc}.str[1,8]")
  end
  
  def load_deactivated
    if db_value_true?(self.deactivated)
      self.deactivated = DB_TRUE
      return true
    else
      self.deactivated = DB_FALSE
      return false
    end
  end
    
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  roles              :string(255)
#  username           :string(255)
#  encrypted_password :string(255)
#  password_salt      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

