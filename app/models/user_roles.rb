module UserRoles
  # module for the user class

  # roles_in parameter should be the roles string
  def init_user_roles(roles_in)
	  Rails.logger.error("* UserRoles - init_user_roles - role_in is an array !!!") if roles_in.instance_of?(Array)
    self.roles = DEFAULT_ROLE.join(' ')
    self.add_roles (roles_in)
  end
  
	# class method to confirm if a role (string) is in the Valid Roles array
	def self.is_valid_role? (role_in)
    # self.validate_valid_roles
		if VALID_ROLES.index(role_in) == nil
			false
		else
			true
		end
	end
	
	# instance method to confirm if a role (string) is in the Valid Roles array
	def is_valid_role? (role_in)
		if VALID_ROLES.index(role_in) == nil
			false
		else
			true
		end
	end
	
	# public method to confirm if a role (string) is not in the Valid Roles array
	def self.is_not_valid_role? (role_in)
		!self.is_valid_role? (role_in)
	end

	# instance method to confirm if a role (string) is not in the Valid Roles array
	def is_not_valid_role? (role_in)
		!self.is_valid_role? (role_in)
	end

	def add_role (role_in)
    # Rails.logger.debug("* UserRoles - add_role - role_in:#{role_in.inspect.to_s}")
	  working_roles = (self.roles.nil?)? [] : self.roles.split(' ')
		if self.is_not_valid_role? (role_in)
      Rails.logger.debug ("#{self.class}.add_role #{role_in.to_s} that self.is_not_valid_role?")
      errors.add(:base, I18n.translate('users.messages.invalid_role', :role => role_in.to_s) )
			false
		elsif (working_roles.index(role_in) == nil)
			working_roles << role_in
			self.roles = working_roles.join(' ')
      # Rails.logger.debug("* UserRoles - add_role - self.roles:#{self.roles.inspect.to_s}")
			true
		else
		  false   # not added, already in
		end
	end
	
  # roles_in parameter should be the roles string
	def add_roles (roles_in)
	  Rails.logger.error("* UserRoles - add_roles - role_in is an array !!!") if roles_in.instance_of?(Array)
	  if !roles_in.nil?
	    roles_in.split(' ').each do |role|
	      add_role(role)
	    end
	  end
	end
	
	# public instance method to remove a role from the Assigned Roles array (@assigned_roles)
	def remove_role (role_in)
    # Rails.logger.debug ("#{self.class}.remove_role(#{role_in.to_s})")
	  working_roles = (self.roles.nil?) ? [] : self.roles.split(' ')
		role_at =  working_roles.index(role_in)
		if !role_at.nil?
			working_roles.delete_at(role_at)
			self.roles = working_roles
      # Rails.logger.debug ("#{self.class}.remove_role is now #{@assigned_roles.to_s}")
			true
		else
      # Rails.logger.debug ("#{self.class}.remove_role #{role_in.to_s} that is not in @assigned_roles")
			false
		end
	end
	
	# public instance method to confirm if a user has been assigned a role.
	def has_role? (role_in)
	  working_roles = (self.roles.nil?)? [] : self.roles.split(' ')
		working_roles.index(role_in) != nil
	end
	
	def validate_assigned_roles
    Rails.logger.debug("* UserRoles - validate_assigned_roles - roles:#{self.roles.inspect.to_s}")
    validated_roles = []
	  DEFAULT_ROLE.each do |role|
      validated_roles << role
    end
    work_roles = (self.roles.nil?) ? '' : self.roles
    # work_roles.flatten if work_roles.instance_of?(Array)
	  work_roles.split(' ').each do |role|
	    if self.is_valid_role? (role)
        validated_roles << role if validated_roles.index(role).nil?
      else
        Rails.logger.debug("* UserRoles - validate_assigned_roles - invalid role:#{role}")
        errors.add(:roles, I18n.translate('users.messages.invalid_role', :role => role.to_s) )
      end
    end
    Rails.logger.debug("* UserRoles - validate_assigned_roles - validated_roles:#{validated_roles.inspect.to_s}")
    self.roles = validated_roles.join(' ')
	end
	
	def assigned_roles
	  working_roles = (self.roles.nil?)? [] : self.roles.split(' ')
	end

end