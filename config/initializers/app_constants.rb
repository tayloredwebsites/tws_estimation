
#######################
# Application Constants
#######################

DB_TRUE = true
DB_TRUE_VALUES = [true, 'T', 'true', 'True', 'TRUE', '1']
DB_FALSE = false
DB_FALSE_VALUES = [false, 'F', 'false', 'False', 'FALSE', '0']

DB_VALUES = {
  :T => true,
  :t => true,
  :true => true,
  :True => true,
  :TRUE => true,
  :F => false,
  :f => false,
  :false => false,
  :False => false,
  :FALSE => false,
}

# Roles used for cancan implementation (to do) (see app/models/roles.rb, app/models/ability.rb)
# each role has layout: (application_name/all)_(role_name/guest)
APPLICATION_SYSTEMS = {
  :all => {:id => 'all', :actual => 'false', :type => 'system'},
#  :home => {:id => 'home', :actual => 'true', :type => 'shared'},
  :guest => {:id => 'guest', :actual => 'true', :type => 'shared'},
  :maint => {:id => 'maint', :actual => 'true', :type => 'shared'},
  :estim => {:id => 'estim', :actual => 'true', :type => 'shared'},
  :prevail => {:id => 'prevail', :actual => 'true', :type => 'external'}
}

VALID_ROLES = %w{ guest_users all_admins maint_users maint_admins estim_users estim_admins prevail_users prevail_admins }
DEFAULT_ROLE = %w{ guest_users }
USER_SELF_NO_UPDATE_FIELDS = %w{ roles deactivated }  # fields that normal users cannot update for themself
USER_SELF_UPDATE_ROLES = %w{ all_admins maint_admins }  # users with these roles can update 'no update' fields regardless of USER_SELF_NO_UPDATE_FIELDS

VALID_EMAIL_EXPR = /^[a-zA-Z0-9!#$\%&'*+-\/=?^_`{|}~\-]*@(?:controlledair\.com|me\.com|gmail\.com|example\.com)$/

SESSION_TIMEOUT_SECONDS = 30*60    # 30 minutes
SESSION_INFO_DEFAULTS = {
  :show_deactivated => DB_FALSE
}
# used by UserSession.set_info for updating the session information
VALID_SESSION_INFO = %w{ sign_in_time time_last_accessed current_user_id session_id _csrf_token show_deactivated original_uri }

