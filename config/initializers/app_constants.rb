
#######################
# Application Constants
#######################

SESSION_TIMEOUT =  8.hours.ago

# Roles used for cancan implementation (to do) (see app/models/roles.rb, app/models/ability.rb)
# each role has layout: (application_name/all)_(role_name/guest)
APPLICATION_SYSTEMS = %w{ maint estim prevail }
VALID_ROLES = %w{ all_guests all_admins maint_guests maint_users maint_admins estim_guests estim_users estim_admins prevail_guests prevail_users prevail_admins }
DEFAULT_ROLE = %w{ all_guests }
USER_SELF_NO_UPDATE_FIELDS = %w{ roles }

VALID_EMAIL_EXPR = /^[a-zA-Z0-9!#$\%&'*+-\/=?^_`{|}~\-]*@(?:controlledair\.com|me\.com|gmail\.com|example\.com)$/

SESSION_TIMEOUT_SECONDS = 30*60    # 30 minutes
