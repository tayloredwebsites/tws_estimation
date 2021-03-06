
#######################
# Application Constants
#######################

# set depending upon database storage of booleans (postgres) or not (sql server)
DB_TRUE = true
# DB_TRUE = "1"
# DB_TRUE = ActiveRecord::Base.connection.quoted_true
DB_TRUE_VALUES = [true, 't', 'T', 'true', 'True', 'TRUE', '1', ActiveRecord::Base.connection.quoted_true]
DB_FALSE = false
# DB_FALSE = "0"
# DB_FALSE = ActiveRecord::Base.connection.quoted_false
DB_FALSE_VALUES = [false, 'f', 'F', 'false', 'False', 'FALSE', '0', ActiveRecord::Base.connection.quoted_false]
VIEWS_SCRIPTING = true
BIG_DECIMAL_ZERO = BigDecimal.new('0.00',2)
BIG_DECIMAL_PERCENT = BigDecimal.new('0.01',2)  # 0.01000001 to ensure .5 rounds up ?

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
# each resource is the available resources(model/controller) under that system with authorization by cancan - app/models/ability.rb
# i18n translations of each menu_item is
# - en.menu_items.{menu_items(key)}.menu_items.{menu_items(key)}
# - en.menu_items.{:app_id}.menu_items.{the menu_item}
# - e.g. en.menu_items.estim.menu_items.state_component_type_taxes
MENU_ITEMS = {
#  :all => {:id => 'all', :actual => 'false', :type => 'system', :resources => ['Home', 'User', 'Default']},
#  :home => {:id => 'home', :actual => 'true', :type => 'shared'},
  :guest => {:app_id => 'guest', :roles => ['guest_users'], :menu_items => {
    :home => {:class_name => "UserSession", :action => :index, :start_uri => "/"},
    :user_signin => {:class_name => "UserSession", :action => :sign_in, :start_uri => "/signin"},
    :user_signout => {:class_name => "UserSession", :action => :sign_out, :start_uri => "/signout"}
    } },
  :maintuser => {:app_id => 'maint', :roles => ['maint_users'], :menu_items => {
    :edit_password => {:class_name => "User", :action => :edit_password, :start_uri => "/edit_password"}
    } },
  :maint => {:app_id => 'maint', :roles => ['maint_admins', 'all_admins'], :menu_items => {
    :users => {:class_name => "User", :action => :index, :start_uri => "/users"},
    :edit_password => {:class_name => "User", :action => :edit_password, :start_uri => "/edit_password"}
  } },
  :estimuser => {:app_id => 'estim', :roles => ['estim_users'], :menu_items => {
    :estim_list => {:class_name => "Estimate", :action => :list, :start_uri => "/estimates/list" },
    :estim_new => {:class_name => "Estimate", :action => :new, :start_uri => "/estimates/new" }
  } },
  :estimadmin => {:app_id => 'estim', :roles => ['estim_admins', 'all_admins'], :menu_items => {
    :estim_admin => {:class_name => "Estimate", :action => :menu, :start_uri => "/estimates/menu", :menu_items => {
      :estimates_index => {:class_name => "Estimate", :action => :index, :start_uri => "/estimates"},
      :estimates_list => {:class_name => "Estimate", :action => :list, :start_uri => "/estimates/list"},
      :estimates_new => {:class_name => "Estimate", :action => :new, :start_uri => "/estimates/new"}
    } },
  } },
  :estimmaint => {:app_id => 'estim', :roles => ['estim_admins', 'all_admins'], :menu_items => {
    :defaults => {:class_name => "Default", :action => :index, :start_uri => "/defaults"},
    :component_types => {:class_name => "ComponentType", :action => :index, :start_uri => "/component_types"},
    :components => {:class_name => "Component", :action => :menu, :start_uri => "/components/menu", :menu_items => {
      :components_index => {:class_name => "Component", :action => :index, :start_uri => "/components"},
      :components_list => {:class_name => "Component", :action => :list, :start_uri => "/components/list"}
    } },
    :assemblies => {:class_name => "Assembly", :action => :menu, :start_uri => "/assemblies/menu", :menu_items => {
      :assemblies_index => {:class_name => "Assembly", :action => :index, :start_uri => "/assemblies"},
      :assemblies_list => {:class_name => "Assembly", :action => :list, :start_uri => "/assemblies/list"}
    } },
    :assembly_components => {:class_name => "AssemblyComponent", :action => :menu, :start_uri => "/assembly_components/menu", :menu_items => {
      :assembly_components_index => {:class_name => "AssemblyComponent", :action => :index, :start_uri => "/assembly_components"},
      :assembly_components_list => {:class_name => "AssemblyComponent", :action => :list, :start_uri => "/assembly_components/list"}
    } },
    :sales_reps => {:class_name => "SalesRep", :action => :index, :start_uri => "/sales_reps"},
    :job_types => {:class_name => "JobType", :action => :index, :start_uri => "/job_types"},
    :states => {:class_name => "State", :action => :index, :start_uri => "/states"},
    :state_component_type_taxes => {:class_name => 'StateComponentTypeTax', :action => :index, :start_uri => '/state_component_type_taxes'}
  } },
  :prevail => {:app_id => 'prevail', :roles => ['prevail_users', 'prevail_admins', 'all_admins'], :menu_items => {
  } }
}

VALID_ROLES = %w{ guest_users all_admins maint_users maint_admins estim_users estim_admins prevail_users prevail_admins }
DEFAULT_ROLES = %w{ guest_users }
USER_SELF_NO_UPDATE_FIELDS = %w{ roles deactivated }  # fields that normal users cannot update for themself
USER_SELF_UPDATE_ROLES = %w{ all_admins maint_admins }  # users with these roles can update 'no update' fields regardless of USER_SELF_NO_UPDATE_FIELDS
ADMIN_SET_USER_PASSWORD = true
VALID_EMAIL_EXPR = /^[a-zA-Z0-9!#$\%&'*+-\/=?^_`{|}~\-]*@(?:controlledair\.com|me\.com|gmail\.com|example\.com)$/

SESSION_TIMEOUT_SECONDS = 30*60    # 30 minutes
SESSION_INFO_DEFAULTS = {
  :show_deactivated => DB_FALSE
}
# used by UserSession.set_info for updating the session information
# VALID_SESSION_INFO = %w{ sign_in_time time_last_accessed current_user_id session_id _csrf_token show_deactivated original_uri }
VALID_SESSION_INFO = %w{ sign_in_time time_last_accessed current_user_id session_id _csrf_token show_deactivated }
DONT_REDIRECT_BACK_URI = %w{ /signout }

VALID_GRID_OPERANDS = {'+' => "Add", '-' => "Subtract", '*' => "Multiply", '/' => "Divide", '%' => "Percent"}
VALID_GRID_SCOPES = {'A' => "Assembly break", 'I' => "Component Type break", 'S' => "Subtotal break", 'C' => "Cumulative"} #, 'H' => "Hours (cumulative)"}


