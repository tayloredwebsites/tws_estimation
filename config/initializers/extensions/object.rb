# object helper functions

class Object
	
	# return true if nil or zero
  def nil_zero?()
    self.nil? || self == 0
  end
	
	# wrapper to return empty string if nil
	def nil_to_s()
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
	
	# wrapper to return 0 if nil
	def nil_to_0()
		(self.nil?) ? 0 : self
	end

end
