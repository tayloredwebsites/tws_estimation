class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :username, :deactivated
  validates_presence_of :email, :username
  
  after_initialize :init
  
  scope :deactivated, where(:deactivated => true)
  scope :active, where(:deactivated => !true)
  
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


  protected
  
  # coding for after class initialization is done
  def init
    self.deactivated ||= false  # set deactivated to false if initialized to nil
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

