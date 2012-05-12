
class Ability
  include CanCan::Ability
    
  def initialize(user)  #, session)

    user ||= User.new
    
    Rails.logger.debug("* Ability - initialize - current user:#{user.full_name}, with roles:#{user.roles.inspect.to_s}")
    cannot :sign_out, UserSession
    if user.can_see_app?('guest')
      if user.has_role? 'guest_users'
        #let all users do these, since all_guests is a required role
        can :reset_password, User
        can :errors, User
        can [:sign_in, :index], UserSession
      end
    end
    if user.can_see_app?('all')
      if user.has_role? 'all_admins'
        can [:manage, :deactivate, :reactivate], :all
        cannot :deactivate, User, :id => user.id
        can [:reset_password, :edit_password, :update_password], User
        can :sign_out, UserSession
        cannot :sign_in, UserSession
      end
    end
    if user.can_see_app?('maint')
      if user.has_role? 'maint_admins'
        can [:manage, :deactivate, :reactivate], User
        cannot :deactivate, User, :id => user.id
        can [:reset_password, :edit_password, :update_password], User
      elsif user.has_role? 'maint_users'
        can [:read, :update], User, :id => user.id
        can [:reset_password, :edit_password, :update_password], User, :id => user.id
        cannot :index, User
      end
      can :sign_out, UserSession
      cannot :sign_in, UserSession
    end
    if user.can_see_app?('estim')
      if user.has_role? 'estim_admins'
        can [:manage, :deactivate, :reactivate], [Default, ComponentType, Component, Assembly, AssemblyComponent, SalesRep, JobType, State, Estimate]
      elsif user.has_role? 'estim_users'
        can :read, [Default, ComponentType, Component, Assembly, AssemblyComponent, SalesRep, JobType, State]
        can [:manage, :deactivate, :reactivate], Estimate
      end
      can :sign_out, UserSession
      cannot :sign_in, UserSession
    end
    
    # # debugging cancan authorize! # note cannot prevent self update of roles by cancan - it only filters records available
    # ability = Ability.new(@user)
    # Rails.logger.debug("* UsersController - update - ability.can?(:update, @user):#{ability.can?(:update, @user)}") # see if user can access the user
    # Rails.logger.debug("* Ability - initialize - User.accessible_by(self):#{User.accessible_by(self).inspect.to_s}") # see if returns the records the user can access
    # Rails.logger.debug("* Ability - initialize - User.accessible_by(self):#{User.accessible_by(self).to_sql}") # see what the generated SQL looks like
    # Rails.logger.debug("* UsersController - update - ''.to_sql:#{User.accessible_by(ability).to_sql}") # see what the generated SQL looks like
    # # end debugging cancan authorize!
    
  end
  
end

