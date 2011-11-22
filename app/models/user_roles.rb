module UserRoles
  # module for the user class

  def init_user_roles(roles)
    @assigned_roles = []
    roles.each do |role|
      # Rails.logger.debug("* UserRoles - init_user_roles - testing role #{role}")
      if self.is_valid_role?(role)
        # Rails.logger.debug("* UserRoles - init_user_roles - valid role #{role}")
        @assigned_roles.push(role)
        # Rails.logger.debug("* UserRoles - init_user_roles - @assigned_roles.size #{@assigned_roles.size}")
      end
    end
    @valid_roles = []
    VALID_ROLES.each do |role|
      @valid_roles.push(Role.new(role))
    end
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
    # validate_assigned_roles
		if User::UserRoles.is_not_valid_role? (role_in)
			Rails.logger.debug ("#{self.class}.add_role #{role_in.to_s} that self.is_not_valid_role?")
			false
		elsif (@assigned_roles.index(role_in) == nil)
			@assigned_roles << role_in
			true
		end
	end
	
	# public instance method to remove a role from the Assigned Roles array (@assigned_roles)
	def remove_role (role_in)
		Rails.logger.debug ("#{self.class}.remove_role(#{role_in.to_s})")
    # validate_assigned_roles
		role_at =  @assigned_roles.index(role_in)
		if role_at != nil
			@assigned_roles.delete_at(role_at)
			Rails.logger.debug ("#{self.class}.remove_role is now #{@assigned_roles.to_s}")
			true
		else
			Rails.logger.debug ("#{self.class}.remove_role #{role_in.to_s} that is not in @assigned_roles")
			false
		end
	end
	
	# public instance method to confirm if a user has been assigned a role.
	def has_role? (role_in)
		@assigned_roles.index(role_in) != nil
	end
	
	def validate_assigned_roles
	  self.roles = DEFAULT_ROLE if self.roles.nil?
	  self.init_user_roles(DEFAULT_ROLE) if self.assigned_roles.nil?
	  if !self.has_role?(DEFAULT_ROLE[0])
      self.add_role(DEFAULT_ROLE[0])
    end
	end
	
	def valid_roles
	  @valid_roles
	end
	
	def assigned_roles
	  @assigned_roles
	end
	
	protected
	
	def unload_assigned_roles
	  validate_assigned_roles
    self.roles=self.assigned_roles
    # Rails.logger.debug("* UserRoles - unload_assigned_roles - roles before = #{self.roles.to_s}")
    # Rails.logger.debug("* UserRoles - unload_assigned_roles - assigned_roles = #{self.assigned_roles.inspect.to_s}")
	  self.roles = (self.roles.nil?) ? self.roles : @assigned_roles.join(' ')
    # Rails.logger.debug("* UserRoles - unload_assigned_roles - roles after = #{self.roles.to_s}")
	end

	def load_assigned_roles
	  validate_assigned_roles
    # Rails.logger.debug("* UserRoles - unload_assigned_roles - assigned_roles before = #{self.assigned_roles.inspect.to_s}")
    # Rails.logger.debug("* UserRoles - unload_assigned_roles - roles = #{self.roles.to_s}")
	  @assigned_roles = self.roles.split(' ')
    # Rails.logger.debug("* UserRoles - unload_assigned_roles - assigned_roles after = #{self.assigned_roles.inspect.to_s}")
	end

end