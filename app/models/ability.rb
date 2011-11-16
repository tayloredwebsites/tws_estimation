
class Ability
  include CanCan::Ability
	
  def initialize(user)

    user ||= User.new # all_guests user
    can :read, :all
    
    #     # UserRoles.user_roles_init
    #     
    #     if user.has_role? 'all_admins'
    #       can :manage, :all
    #   can :deactivate, :all
    #   can :reactivate, :all
    #     elsif user.has_role? 'all_guests'
    #   cannot :read, :all    # set it so that if cannot read, then nothing else can be done
    #   #cannot :selfread, :all
    #   #cannot :selfupdate, :all
    #   #cannot :update, :all
    #   #cannot :selfupdate, :all
    #   #cannot :create, :all
    #   #cannot :deactivate, :all
    #   #cannot :reactivate, :all
    #     elsif user.has_role? 'estim_admins'
    #       can :manage, :all
    #   can :deactivate, :all
    #   can :reactivate, :all
    # elsif user.has_role? 'estim_users'
    #       can :selfread, User, :id => user.id
    #   can :selfupdate, User, :id => user.id
    #   # can only read/update own User record ???
    #       #can :update, Estimate do |estimate|
    #       #  estimate.try(:user) == user
    #       #end
    #     end
    
  end
  
end

