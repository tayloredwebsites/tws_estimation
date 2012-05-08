class Role

  def initialize(*params)
    if params.size > 0
      set_role(params[0])
    else
      clear_role
    end
  end
  
  def set_role(role_id)
    if !role_id.blank?
      role_parts = role_id.split('_')
      if role_parts.size == 2
        @role_app_id = role_parts[0]
        @role_role_id = role_parts[1]
        @role = role_id
      else
        clear_role
      end
    else
      clear_role
    end
  end

  def role
    @role
  end
  
  def app_id
    @role_app_id
  end
  
  def sys_name
   I18n.translate('systems.'+@role_app_id.to_s+'.full_name')
   # @role_app_id
  end
      
  def role_id
    @role_role_id
  end
  
  def role_name
   I18n.translate('roles.'+@role_role_id.to_s+'.full_name')
   # @role_role_id
  end
      
  
  def clear_role
    @role = @role_app_id = @role_role_id = nil
  end
  
  def ==(another_role)
    Rails.logger.debug("* Role - == - #{self.role == another_role.role}, #{self.role}, #{another_role.role}")
    self.role == another_role.role
  end
  def same_sys(another_role)
    Rails.logger.debug("* Role - same_app - #{@role_app_id == another_role.app_id}, #{@role_app_id}, #{another_role.app_id}")
    @role_app_id == another_role.app_id
  end
  def same_role(another_role)
    Rails.logger.debug("* Role - same_role - #{self.role_id == another_role.role_id}, #{self.role_id}, #{another_role.role_id}")
    self.role_id == another_role.role_id
  end
  

      
end
  
