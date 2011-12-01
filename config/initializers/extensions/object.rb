# object helper functions

class Object
	
	# return true if nil or zero
  def nil_zero?
    self.nil? || self == 0
  end
	
	# wrapper to return empty string if nil
	def no_nil_str(obj)
		if obj == nil
			return ''
		else
			return obj
		end
	end
	
end
