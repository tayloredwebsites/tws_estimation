class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :username, :deactivated, :password, :password_confirmation
  validates_presence_of :email, :username
  attr_accessor :password
  validates :password,
      # :presence => true,
      :confirmation => true
   
  before_save :validate_save
  #before_update_password :validate_password
  
  after_initialize :init
  
  scope :deactivated, where(:deactivated => true)
  scope :active, where(:deactivated => !true)
  
  def create
    logger.debug ("create has errors: ") if !errors.empty?
    logger.debug (errors.to_a) if !errors.empty?
    super if errors.empty?
  end
  
  def save
    logger.debug ("save has errors: ") if !errors.empty?
    logger.debug (errors.to_a) if !errors.empty?
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
  	  logger.debug('User is active on deactivate method - OK to deactivate.')
			self.deactivated = true;
			if !self.save
			  errors.add(:base, I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.got_error') ) )
			  errors.add(:deactivated, I18n.translate('error_messages.got_error') )
			  return false
			end
  	else
  	  logger.debug('User is already deactivated on deactivate method.')
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


  def self.valid_password? (username, password, password_confirmation=nil)
    logger.debug('username:'+username.to_s)
    logger.debug('password:'+password.to_s)
    logger.debug('password_confirmation:'+password_confirmation.to_s)
    auth_user = find_by_username(username)
    if auth_user.nil?
      logger.debug ("cannot find username")
      return nil
    else
      auth_user.password = auth_user.password_confirmation = password
      auth_user.password_confirmation = password_confirmation if !password_confirmation.nil?
      auth_user.validate_password
      logger.debug ("validate_password errors") if auth_user.errors.count > 0
      return (auth_user.errors.count == 0 ? auth_user : nil)
    end
  end

  # validate password fields and place errors into active model errors
  # good for create or udpate
  def validate_password
    if self.new_record?
      logger.debug ("missing password")
      errors.add(:password, I18n.translate('error_messages.missing_password') ) if self.password.blank?
    end
    if !self.password.blank?
      logger.debug("have a password")
      if self.password != self.password_confirmation
        logger.debug("password mismatch")
        errors.add(:password_confirmation, I18n.translate('error_messages.password_mismatch') )
      else
        logger.debug("invalid password - pwd : "+self.password)
        logger.debug("invalid password - !new record? : "+(!self.new_record?).to_s)
        logger.debug("invalid password - !has_matching_password? : "+(!has_matching_password?).to_s)
        errors.add(:password, I18n.translate('error_messages.invalid_password') ) if !self.new_record? && !has_matching_password?
      end
    end
  end
  

  private
 
  # coding for after class initialization is done
  def init
    self.deactivated ||= false  # set deactivated to false if initialized to nil
  end
  
  # if passing in password, validate it before save (validate if password is not blank)
  def validate_save
    self.validate_password
    encrypt_password if errors.count == 0
  end
    
  # see if password passed in matches the encryped password
  def has_matching_password?
    if self.password.blank? || self.encrypted_password.blank?
      false
    else
      self.encrypted_password == encrypt(self.password)
    end
  end
  
  def encrypt_password
    self.password_salt = generate_salt if self.new_record?
    self.encrypted_password = encrypt(self.password)
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

