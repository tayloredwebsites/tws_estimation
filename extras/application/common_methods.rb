module Application::CommonMethods
  
  ######################################################
  # common methods to be available across application
  ######################################################
  
  # is the field value from the database a true or false value
  # uses constants set up in config/initializers/app_constants.rb
  def db_value_true?(field_value)
    if field_value.nil?
      return false
    elsif !DB_TRUE_VALUES.index(field_value.to_s).nil?
      return true
    elsif !DB_FALSE_VALUES.index(field_value.to_s).nil?
      return false
    else
      Rails.logger.error("*Error ApplicationHelper - db_true_value?(#{field_value.inspect.to_s}) has unmatched value!")
      return false
    end
  end
    
end

