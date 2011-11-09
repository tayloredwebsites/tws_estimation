
#######################
# Application Constants
#######################

SESSION_TIMEOUT =  8.hours.ago

# Roles used for cancan implementation (to do) (see app/models/roles.rb, app/models/ability.rb)
# each role has layout: (application_name/all)_(role_name/guest)
VALID_ROLES = %w( AllGuests AllAdmins EstimUsers EstimAdmins )
DEFAULT_ROLE = ['AllGuests']

VALID_EMAIL_EXPR = /^[a-zA-Z0-9!#$\%&'*+-\/=?^_`{|}~\-]*@(?:controlledair\.com|me\.com|gmail\.com|example\.com)$/

SESSION_TIMEOUT_SECONDS = 30*60    # 30 minutes
