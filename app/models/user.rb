class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :username, :deactivated, :password, :password_confirmation, :old_password
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
   
  before_save :validate_save
  #before_update_password :validate_password
  
  after_initialize :init
  
  scope :deactivated, where(:deactivated => true)
  scope :active, where(:deactivated => !true)
  
  def create
    logger.debug ("create has errors: "+errors.to_a) if !errors.empty?
    super if errors.empty?
  end
  
  def save
    logger.debug ("save has errors: "+errors.to_a) if !errors.empty?
    super if errors.empty?
  end
  
  # method to delete a record, only if it is already deactivated
  def delete
  	if self.deactivated == false
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
  	if self.deactivated == false
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
  	if !self.deactivated
			self.deactivated = true;
			if !self.save
			  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.got_error') ) )
			  errors.add(:deactivated, I18n.translate('error_messages.got_error') )
			  return false
			end
  	else
		  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') ) )
			errors.add(:deactivated, I18n.translate('error_messages.is_deactivated') )
			return false
  	end
  	return true
  end

  # method to reactivate record
  def reactivate
  	if self.deactivated
			self.deactivated = false;
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

  # class level valid_password to check password against user in database
  def self.valid_password? (username, password, password_confirmation=nil)
    auth_user = find_by_username(username) if !username.nil?
    if auth_user.nil?
      return nil
    else
      auth_user.password = auth_user.password_confirmation = password
      auth_user.password_confirmation = password_confirmation if !password_confirmation.nil?
      auth_user.validate_password
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
  
  def update_attributes(params)
    if valid_password_change?(params)
      self.password = params[:password]
      self.password_confirmation = params[:password_confirmation]
      params.delete(:old_password)
      encrypt_password
    else
      params.delete(:old_password)
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    super(params)
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
    logger.debug('reset_password: '+self.password.to_s)
  end
  
  
  
  def full_name
    name = ''
    name += self.first_name if !self.first_name.nil?
    name += ' ' + self.last_name if !self.last_name.nil?
    return name
  end
  
  
  private
 
  # coding for after class initialization is done
  def init
    self.deactivated ||= false  # set deactivated to false if initialized to nil
  end
  
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

