module Models::UserRoles
  extend ActiveSupport::Concern
  
  # module for the user class
  
  included do
    before_save :validate_roles_save
  end

  # validation before save
  def validate_roles_save
    # Rails.logger.debug("* Models::UserRoles.validate_roles_save")
    self.roles = validate_roles(self.roles)
    # Rails.logger.debug("* Models::UserRoles.validate_roles_save done self:#{self.inspect.to_s}")
    return true # always update
  end

  module ClassMethods

  	def is_valid_role? (role_in)
  	  (VALID_ROLES.index(role_in.to_s) == nil) ? false : true
  	end

  end
  
  # roles_in parameter should be the roles string
  def init_user_roles(roles_in = nil)
    # Rails.logger.debug("* Models::UserRoles.init_user_roles - #{self.username.to_s} roles_in:#{roles_in.inspect.to_s}")
    self.roles = DEFAULT_ROLES.join(' ')
    self.add_roles (roles_in)
  end
  
  def load_user_roles()
    self.init_user_roles(self.roles)
  end
  
	# instance method to confirm if a role (string) is in the Valid Roles array
	def is_valid_role? (role_in)
	  # Rails.logger.debug("* Models::UserRoles.is_valid_role? *** instance *** - role_in:#{role_in.inspect.to_s}")
	  valid_role? (role_in)
	end
	
	def valid_role? (role_in)
  	(VALID_ROLES.index(role_in.to_s) == nil) ? false : true
	end
	
	def add_role (role_in)
    # Rails.logger.debug("* UserRoles - add_role - role_in:#{role_in.inspect.to_s}")
    cur_roles = to_array_if_not(self.roles)
    role_at = (cur_roles).index(role_in.to_s)
		if !role_at.nil?
		  false   # not added, already in
		elsif !valid_role? (role_in)
			false
		else
			self.roles = (cur_roles << role_in).join(' ')
			true
		end
	end
	
  # add string or array of roles (validated by add_role method)
	def add_roles (roles_in)
	  roles_in = to_array_if_not(roles_in)
    roles_in.each do |role|
      add_role(role)
    end
    # Rails.logger.debug("* UserRoles - add_role - updated - self.roles:#{self.roles.inspect.to_s}")
	end
	
  # public instance method to remove a role from the assigned roles
  def remove_role (role_in)
    Rails.logger.debug ("#{self.class}.remove_role(#{role_in.to_s}) - #{self.username.to_s} ")
    cur_roles = to_array_if_not(self.roles)
    role_at = (cur_roles).index(role_in)
    if role_at != nil
       cur_roles.delete_at(role_at)
      self.roles = cur_roles.join(' ')
      true
    else
      false
    end
  end
	
	# public instance method to confirm if a user has been assigned a role.
	def has_role? (role_in)
	  # Rails.logger.debug("* Models::UserRoles.has_role? self.roles:#{self.roles}, role_in:#{role_in}")
		(to_array_if_not(self.roles)).index(role_in.to_s) != nil
	end
	
	# method to return a string of validated roles from the roles passed in
	def validate_roles(new_roles)
    Rails.logger.debug("* UserRoles - validate_roles - #{self.username.to_s} new_roles:#{new_roles.inspect.to_s}")
    new_roles = (to_array_if_not(new_roles) | DEFAULT_ROLES)
    Rails.logger.debug("* UserRoles - validate_roles - (new_roles | DEFAULT_ROLES):#{(new_roles | DEFAULT_ROLES).inspect.to_s}")
 	  new_roles.each do |role|
	    if !valid_role? (role)
        new_roles.delete(role)
      end
    end
    Rails.logger.debug("* UserRoles - validate_roles - #{self.username.to_s} new_roles:#{new_roles.inspect.to_s}")
    return new_roles.join(' ')
	end
	
	# method to return the assigned roles for a user
	def assigned_roles
    to_array_if_not(self.roles)
	end

end