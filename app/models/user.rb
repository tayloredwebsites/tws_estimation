class User < ActiveRecord::Base

  include Models::UserRoles
  include Application::CommonMethods
  # include Models::CommonMethods
  include Models::Deactivated

  attr_accessible :first_name, :last_name, :email, :username, :deactivated, :password, :password_confirmation, :old_password, :roles
  attr_accessor :password, :old_password

  has_one :sales_rep
  # has_many :estimates, :through => :sales_rep

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

  before_save :validate_save
  after_find :load_user_roles

  def initialize(*args)
    # Rails.logger.debug("* User.initialize args:#{args.inspect.to_s}")
    # init_user_roles([])
    @system = 'maint'
    super(*args)
    # Rails.logger.debug("* User.initialize done")
  end

  def self.guest
    # Rails.logger.debug("* User - self.guest")
    @user = self.new
    @user.id = 0
    @user.username = 'Guest'
    @user.first_name = 'Guest'
    @user.roles =  DEFAULT_ROLES.join(' ')
    Rails.logger.debug("* User.guest - roles: #{@user.roles}")
    return @user
  end

  def self.user_errors
    @user = self.new
    return @user
  end

  def new(*params)
    # Rails.logger.debug("* User.new - params #{params.inspect.to_s}")
    super(*params)
    # Rails.logger.debug("* User.new - done")
  end

  def save
    Rails.logger.debug ("* User.save has errors:#{errors.inspect.to_s}") if !errors.empty?
    # Rails.logger.debug("* User.save - call to validate_save - self:#{self.inspect.to_s}")
    # validate_save
    super if errors.empty? && self.id != 0  # don't save the guest user
  end


  # class level valid_password to check password against user in database
  def self.valid_password? (username, password_in, password_confirmation=nil)
    password_confirmation = password_in if password_confirmation==nil
    # auth_user = User.where("username = ?", username) if !username.nil?
    auth_user = (username.nil?) ? nil : User.find_by_username(username)
    if auth_user.nil?
      Rails.logger.debug('* User.valid_password? - username not found')
      err_user = User.user_errors()
      err_user.errors.add(:password, I18n.translate('error_messages.invalid_password') ) # no errors object because this is a class method
      return err_user
    else
      # Rails.logger.debug('* User.valid_password? - auth_user:'+auth_user.inspect.to_s)
      if auth_user.has_password?(password_in)
        return auth_user
      else
        err_user = User.user_errors()
        err_user.errors.add(:password, I18n.translate('error_messages.invalid_password') ) # no errors object because this is a class method
        return err_user
      end
    end
  end

  # instance level password check against current user
  def has_password? (password_in, password_confirmation=nil)
    if !password_confirmation.nil? && password_in != password_confirmation
      Rails.logger.debug("* User.has_password? - #{I18n.translate('error_messages.password_mismatch')}")
      errors.add(:password, I18n.translate('error_messages.password_mismatch') )
      errors.add(:password_confirmation, I18n.translate('error_messages.password_mismatch') )
      false
    elsif self.encrypted_password != encrypt(password_in)
      Rails.logger.debug("* User.has_password? - #{I18n.translate('error_messages.invalid_password')}")
      # Rails.logger.debug("* User.has_password? - #{password_in.inspect.to_s}")
      errors.add(:password, I18n.translate('error_messages.invalid_password') )
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
        errors.add(:password, I18n.translate('error_messages.password_mismatch') )
        errors.add(:password_confirmation, I18n.translate('error_messages.password_mismatch') )
      else
        errors.add(:password, I18n.translate('error_messages.invalid_password') ) if !self.new_record? && !has_matching_password?
      end
    end
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

  # does this user have this system in any of its roles?
  def can_see_app?(system)
    matched_roles = self.roles.split(' ').delete_if{|r| (r.index(system.to_s+'_').nil? && r.index('all_').nil?)}
    #Rails.logger.debug("* User.can_see_app? - system:#{system}, roles:#{self.roles}, matched_role:#{matched_roles}")
    return matched_roles.size > 0
  end

  def update_attributes(params)
    # Rails.logger.debug("* User - update_attributes - params=#{params.inspect.to_s}")
    # Rails.logger.error("* UserRoles - update_attributes - roles is an array !!!") if params[:roles].instance_of?(Array)
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
      # Rails.logger.debug("* User.update_attributes call validate_roles on params:#{params.inspect.to_s}")
      params[:roles]=validate_roles(params[:roles])
      # Rails.logger.debug("* User.update_attributes updated params:#{params.inspect.to_s}")
    end
    # Rails.logger.debug("* User.update_attributes - before call to super - self:#{self.inspect.to_s}")
    super(params) if errors.empty?
    # Rails.logger.debug("* User.update_attributes - after call to super - self:#{self.inspect.to_s}")
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
      errors.add(:password_confirmation, I18n.translate('error_messages.password_mismatch') )
    end
  end


  def valid_password_change?(params)
    if params[:old_password].blank?
      # cannot be a password change if there is no old password
      false
    elsif params[:password].blank?
      false
    elsif params[:password] != params[:password_confirmation]
      errors.add(:password, I18n.translate('error_messages.password_mismatch') )
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

  # validation before save
  # if passing in password, validate it before save (validate if password is not blank)
  def validate_save
    # self.validate_roles(self.roles)
    # self.validate_deactivated
    self.validate_password
    Rails.logger.error("E* User.validate_save errors on validate_password errors:#{errors.inspect.to_s}") if errors.count > 0
    if errors.count == 0
      encrypt_password
      return true
    else
      return false
    end
  end

  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    ''+super.nil_to_s+self.last_name.nil_to_s+', '+self.first_name.nil_to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end


  private

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
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  deactivated        :boolean
#

