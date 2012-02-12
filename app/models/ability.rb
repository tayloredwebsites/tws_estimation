
class Ability
  include CanCan::Ability
	
  def initialize(user)  #, session)

    user ||= User.new # all_guests user
    
    # can :manage, :all    # remove all role checks for testing
    
    Rails.logger.debug("* Ability - initialize - current user:#{user.full_name}, with roles:#{user.roles.inspect.to_s}")
    if user.has_role? 'all_admins'
      can :manage, :all
      can :deactivate, :all
      cannot :deactivate, User, :id => user.id
      can :reactivate, :all
      can :reset_password, User
      can :edit_password, User
    end
    # if user.has_role? 'all_guests'
    #let all users do these
      can :reset_password, User
      can :errors, User
      can :manage, UserSession
    #end
    if user.has_role? 'maint_admins'
      can :manage, User
      can :deactivate, User
      cannot :deactivate, User, :id => user.id
      can :reactivate, User
      can :reset_password, User
      can :edit_password, User
      can :update_password, User
    end
    if user.has_role? 'maint_users'
      can :read, User, :id => user.id
      can :update, User, :id => user.id
      can :reset_password, User, :id => user.id
      can :edit_password, User, :id => user.id
      can :update_password, User, :id => user.id
      cannot :index, User
      # lockdown of self update of roles in code (this only filters records that can be updated)
    end

    # if user.has_role? 'estim_users'
    #       can :selfread, User, :id => user.id
    #   can :selfupdate, User, :id => user.id
    #   # can only read/update own User record ???
    #       #can :update, Estimate do |estimate|
    #       #  estimate.try(:user) == user
    #       #end
    #     end

    # # debugging cancan authorize! # note cannot prevent self update of roles by cancan - it only filters records available
    # ability = Ability.new(@user)
    # Rails.logger.debug("* UsersController - update - ability.can?(:update, @user):#{ability.can?(:update, @user)}") # see if user can access the user
    # Rails.logger.debug("* Ability - initialize - User.accessible_by(self):#{User.accessible_by(self).inspect.to_s}") # see if returns the records the user can access
    # Rails.logger.debug("* Ability - initialize - User.accessible_by(self):#{User.accessible_by(self).to_sql}") # see what the generated SQL looks like
    # Rails.logger.debug("* UsersController - update - ''.to_sql:#{User.accessible_by(ability).to_sql}") # see what the generated SQL looks like
    # # end debugging cancan authorize!
    
  end
  
end

