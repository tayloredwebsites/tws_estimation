# object helper functions

class Object
    
    # return true if nil or zero
  def nil_zero?()
    self.nil? || self == 0
  end
    
  # wrapper to return empty string if nil
  def nil_to_s
    if self.nil?
      return ''
    else
      begin
        return self.to_s
      rescue Exception => e
        Rails.logger.debug("E Object.nil_to_s error #{e.to_s}")
        return ''
      end
    end
  end
  
  # alternate to nil_to_s, which will return default value if nil
  def nil_to_default(default)
    self.nil? ? '' : self.nil_to_s
  end
  
  # convert nil to big decimal zero
  def bd_to_s(places)
    sprintf("%.#{places.nil_to_default('0')}f", (self.nil? ? BIG_DECIMAL_ZERO : self) )
  end

  # wrapper to return 0 if nil
  def nil_to_0()
      (self.nil?) ? 0 : self
  end

end
