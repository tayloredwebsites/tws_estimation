module Models::Deactivated
  extend ActiveSupport::Concern
  
  # module for the user class
  # module to add deactivated field to a model
  
  included do
    before_save :validate_deactivated
  end

  # check to see if this module is loaded
  # if (defined? @model.deactivated_module) will be true if this module is included
  def deactivated_module
    true
  end
  
  def validate_deactivated
    # Rails.logger.debug("* User.validate_deactivated:#{deactivated.inspect.to_s}")
    self.deactivated = db_value_true?(self.deactivated)
    # Rails.logger.debug("* User.validate_deactivated done => #{deactivated.inspect.to_s}")
    return true # always update
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
    # Rails.logger.debug("* Models::Deactivated.deactivated? self.deactivated:#{self.deactivated.inspect.to_s}")
    if self.deactivated == DB_TRUE
      return true
    elsif self.deactivated == DB_FALSE
      return false
    else
      Rails.logger.warn("! User.deactivated? - invalid value for deactivated:#{self.deactivated.inspect.to_s}")
      validate_deactivated
      return self.deactivated == DB_TRUE
    end
  end
  
  def reactivated?
    return !deactivated?
  end
  
  def active?
    return !deactivated?
  end

end