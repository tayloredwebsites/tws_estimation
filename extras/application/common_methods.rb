module Application::CommonMethods
  
  ######################################################
  # common methods to be available across application
  ######################################################
  
  # is the field value from the database a true or false value
  # uses constants set up in config/initializers/app_constants.rb
  def db_value_true?(field_value, default_value = nil)
    if field_value.nil?
      return false
    elsif field_value == DB_TRUE
      return true
    elsif field_value == DB_FALSE
      return false
    # elsif DB_TRUE_VALUES.index(field_value.to_s).nil?
    elsif DB_TRUE_VALUES.include?(field_value)
      return true
    # elsif !DB_FALSE_VALUES.index(field_value.to_s).nil?
    elsif DB_FALSE_VALUES.include?(field_value)
      return false
    else
      Rails.logger.error("ERROR ApplicationHelper - db_true_value?(#{field_value.inspect.to_s}) has unmatched value!")
      return default_value.nil? ? false : default_value
    end
  end
  
  # if convert string separated words into array if not already
  # empty array if nil
  def to_array_if_not(item)
    if item.nil?
      return []
    elsif item.instance_of?(Array)
      return item.dup()
    elsif item.instance_of?(String)
      return item.split(' ')
    else
      return []
    end
  end
  
end

