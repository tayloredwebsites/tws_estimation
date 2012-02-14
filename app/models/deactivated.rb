module Deactivated
  # module to add deactivated field to a model
  
  # unnecessary
  def initialize(*args)
    # Rails.logger.debug("* .Deactivated.initialize args:#{args.inspect.to_s}")
    super(*args)
  end
  
  # Invalid attempt to add before filters to base class for this module
  #def self.included(base)
  #  Rails.logger.debug("* .Deactivated.self.included - base:#{base.name}")
  #  base.before_save :validate_deactivated
  #end

  # parent class validate_save method must call super for this to happen
  def validate_save
    # Rails.logger.debug("* .Deactivate.validate_save")
    self.validate_deactivated
  end
    
  def validate_deactivated
    # Rails.logger.debug("* User.validate_deactivated:#{deactivated.inspect.to_s}") if self.deactivated != db_value_true?(self.deactivated)
    self.deactivated = db_value_true?(self.deactivated)
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
      Rails.logger.warn("! User.deactivated? - invalid value for deactivated:#{self.deactivated.inspect.to_s}")
      return validate_deactivated
    end
  end
  
  def reactivated?
    return !deactivated?
  end
  
  def active?
    return !deactivated?
  end

end