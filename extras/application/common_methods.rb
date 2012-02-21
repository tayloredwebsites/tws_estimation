module Application::CommonMethods
  
  ######################################################
  # common methods to be available across application
  ######################################################
  
  # is the field value from the database a true or false value
  # uses constants set up in config/initializers/app_constants.rb
  def db_value_true?(field_value)
    if field_value.nil?
      return DB_FALSE
    elsif !DB_TRUE_VALUES.index(field_value.to_s).nil?
      return DB_TRUE
    elsif !DB_FALSE_VALUES.index(field_value.to_s).nil?
      return DB_FALSE
    else
      Rails.logger.error("*Error ApplicationHelper - db_true_value?(#{field_value.inspect.to_s}) has unmatched value!")
      return DB_FALSE
    end
  end
  
  # if convert string separated words into array if not already
  # empty array if nil
  def to_array_if_not(item)
    if item.nil?
      return []
    elsif item.instance_of?(Array)
      return item.clone()
    elsif item.instance_of?(String)
      return item.split(' ')
    else
      return []
    end
  end
  
    
end

