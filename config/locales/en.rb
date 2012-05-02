# config/locales/en.rb
# localization file using ruby hash method (instead of yaml).
{
  :en => {
    # general user displays
    :config => {
      :company_name => 'Taylored Web Sites',
      :company_email => 'tayloredwebsites@me.com',
      :app_name => 'Estimation of systems/component costs',
      :app => 'tws_estimation'  # not used so far
    },
    :systems => {
      :all => {
        :abbreviation => 'All',
        :full_name => 'All Systems',
        :menu_items => {} # not used
      },
      :guest => {
        :abbreviation => 'Common',
        :full_name => 'Common',
        :menu_items => {
          :home => 'Home Page',
          :user_signin => 'Sign In',
          :user_signout => 'Sign Out'
        }
      },
      :maint => {
        :abbreviation => 'Maint.',
        :full_name => 'System Maintenance',
        :menu_items => {
          :users => 'Users'
        }
      },
      :estim => {
        :abbreviation => 'Estimation Maintenance',
        :full_name => 'Estimation Maintenance',
        :menu_items => {
          :defaults => 'Defaults',
          :component_types => 'Component Types',
          :components => 'Components',
          :assemblies => 'Assemblies',
          :assembly_components => 'Assembly Components',
          :sales_reps => 'Sales Reps',
          :job_types => 'Job Taxability Types',
          :states => 'States'
        }
      },
      :estimuser => {
        :abbreviation => 'Estimation',
        :full_name => 'Estimation System',
        :menu_items => {
          :defaults => 'Defaults',
          :component_types => 'Component Types',
          :components => 'Components',
          :assemblies => 'Assemblies'
        }
      },
      :prevail => {
        :abbreviation => 'Prevail',
        :full_name => 'Prevailing Wages',
        :menu_items => {
        }
      }
    },
    :roles => {
      :users => {
        :abbreviation => 'User',
        :full_name => 'User'
      },
      :admins     => {
        :abbreviation => 'Admin',
        :full_name => 'Administrator'
      }
    },
    :warning => {
      :sure? => 'Are you sure?',
      :sure_action? => 'Are you sure you want to %{action}?',
      :sure_action_name? => 'Are you sure you want to %{action} %{name}?',
      :sure_action_id? => 'Are you sure you want to %{action} item with ID: %{id}?'
    },
    :errors => {
      :cannot_find_obj => "Cannot find %{obj}",
      :cannot_find_obj_id => "Cannot find %{obj} with ID %{id}",
      :invalid_record_obj => "Invalid record for %{obj}",
      :invalid_record_obj_id => "Invalid record for %{obj} with ID %{id}",
      :success_method_obj_id => "Successful %{method} of %{obj} with ID %{id}",
      :success_method_obj_name => "Successful %{method} of %{obj} %{name}",
      :success_method_obj_msg => "Successful %{method} of %{obj} %{msg}",
      :success_method => "Successful %{method}",
      :cannot_method_obj_id => "Cannot %{method} of %{obj} with ID %{id}",
      :cannot_method_msg => "Cannot %{method} - %{msg}",
      :invalid_call => 'invalid call to %{method}',
      :invalid_method_argument => 'Method %{method} has invalid argument %{argument}',
      :missing_msg => "Missing %{msg}",
      :obj_does_not_exist => "%{obj} user does not exist",
      :cannot_method_your_obj => "Cannot %{method} your own %{obj}",
      :access_denied_msg_obj => "Access Denied! You have restrictions on doing a %{method} of %{obj}",
      :access_denied_msg => "Access Denied! You have restrictions on doing a %{method} of %{obj}",
      :active_record_error_msg => "Active Record Error! %{msg}",
      :fix_following_errors => "Please fix the following errors and save.",
      :note_errors_below => "Note the errors on specific fields below.",
      :msg => "%{msg}",
      :error_msg => "Error! %{msg}",
      :error_obj_msg => "Error! %{obj} %{msg}",
      :system_error_invalid_role => "System Error! - User assigned an invalid role of %{role}",
      :error_dependencies => "Error! cannot delete, this object has dependent items."
    },
    :error_messages => {
      :is_active => 'is an active record.',
      :is_deactivated => 'is a deactivated record.',
      :you_are_deactivated => 'you are deactivated.',
      :got_error => 'got an error.',
      :missing_password => 'missing password',
      :password_mismatch => 'passwords mismatched',
      :no_password_update => 'cannot update password here',
      :invalid_password => 'invalid username or password, try AdminUser/test or TestUser/test',
      :check_email => 'check your email for next step',
      :is_not_string => 'is not a string'
    },
    :view_field_value => {
      :true => 'truly',
      :false => 'not',
      :deactivated => 'Deactivated',
      :reactivated => 'Active',
      :active => 'Active'
    },
    :view_labels => {
      :phone => 'Phone:',
      :email => 'eMail:',
      :welcome_user => 'Welcome %{user}',
      :company_name => 'Company Name:'
    },
    :view_action => {
      :list => 'List',
      :new => 'New',
      :create => 'Create',
      :edit => 'Edit',
      :update => 'Update',
      :show => 'View',
      :view => 'View',
      :deactivate => 'Deactivate',
      :reactivate => 'Reactivate',
      :destroy => 'Destroy',
      :delete => 'Delete',
      :show_deactivated => 'Show Deactivated',
      :hide_deactivated => 'Hide Deactivated'
    },
    # Resources Display Strings
    # Home pseudo Resource
    :home => {
      :title => 'Home',
      :system => 'home',
      :index => {
        :title => "Home",
        :header => "Home Page"
      },
      :about => {
        :title => "About",
        :header => "About this site"
      },
      :contact => {
        :title => "Contact",
        :header => "Contact us"
      },
      :help => {
        :title => "Help",
        :header => "Help Pages"
      },
      :news => {
        :title => "News",
        :header => "News about us"
      },
      :site_map => {
        :title => "Site Map",
        :header => "Map of the pages of this site"
      },
      :status => {
        :title => "Status",
        :header => "Status page"
      },
      :errors => {
        :title => "Errors",
        :header => "Errors page - Unrecoverable errors"
      }
    }, # end Home pseudo Resource
    # User Resource
    :users => {
      :title => 'Users',
      :system => 'maint',
      :index => {
        :action => "List Users",
        :title => "List Users",
        :header => "List of all users"
      },
      :edit => {
        :action => "Edit User",
        :title => "Edit User",
        :header => "Edit a user"
      },
      :new => {
        :action => "New User",
        :title => "New User",
        :header => "Create a new User"
      },
      :show => {
        :action => "View User",
        :title => "View User",
        :header => "View a user"
      },
      :edit_password => {
        :action => "Edit Password",
        :title => "Edit Password",
        :header => "Edit your User Password "
      },
      :reset_password => {
        :action => "Reset Password",
        :title => "Reset Password",
        :header => "Reset your User Password"
      },
      :field_name => {
        :id => 'ID',
        :first_name => 'First Name',
        :last_name => 'Last Name',
        :email => 'Email Address',
        :roles => 'Authorized Roles',
        :username => 'Username',
        :password => 'Password',
        :password_confirmation => 'Password Confirmation',
        :deactivated => 'Deactivated'
      },
      :field_name_short => {
        :id => 'ID',
        :first_name => 'First',
        :last_name => 'Last',
        :email => 'Email',
        :roles => 'Roles',
        :username => 'Username',
        :password => 'Password',
        :password_confirmation => 'Confirmation',
        :deactivated => 'Deactivated'
      },
      :messages => {
      #  :session_timeout => 'Your session has timed out',
      #  :invalid_role => "Invalid role %{role} has been removed"
      }
    }, # end User Resource
    # UsersSessionResource
    :users_sessions => {
      :title => 'User Sessions',
      :system => 'estimmaint',
      :index => {
        :title => "Main Menu",
        :header => "Main Menu"
      },
      :signin => {
        :title => "Sign In",
        :header => "Sign In",
        :action => "Sign In"
      },
      :create => {
        :title => "Signed In",
        :header => "Signed in"
      },
      :signout => {
        :title => "Signed Out",
        :header => "Signed out",
        :action => "Sign Out"
      },
      :field_name => {
        :username => 'Username',
        :password => 'Password'
      },
      :field_name_short => {
        :username => 'Username',
        :password => 'Password'
      },
      :messages => {
        :session_timeout => 'Your session has timed out'
      }
    }, # end UsersSession Resource
    # Default Resource
    :defaults => {
      :title => 'Default Values',
      :system => 'estimmaint',
      :index => {
        :action => "List Default Values",
        :title => "List Installations Default Values",
        :header => "List of all Default Values"
      },
      :edit => {
        :action => "Edit Default Value",
        :title => "Edit Default Value",
        :header => "Edit a Default Value"
      },
      :new => {
        :action => "New Default Value",
        :title => "New Default Value",
        :header => "Create a new User"
      },
      :show => {
        :action => "View Default Value",
        :title => "View Default Value",
        :header => "View a Default Value"
      },
      :field_name => {
        :id => 'ID',
        :store => 'Value Store',
        :name => 'Name',
        :value => 'Value',
        :deactivated => 'Deactivated'
      },
      :field_name_short => {
        :id => 'ID',
        :store => 'Store',
        :name => 'Name',
        :value => 'Value',
        :deactivated => 'Deactivated'
      },
      :messages => {
      }
    }, # end Default Resource
    # ComponentType Resource
    :component_types => {
      :title => 'Component Types',
      :system => 'estimmaint',
      :index => {
        :action => "List Component Types",
        :title => "List Estimation Component Types",
        :header => "List of all Estimation Component Types"
      },
      :edit => {
        :action => "Edit Component Type",
        :title => "Edit Component Type",
        :header => "Edit a Component Type"
      },
      :new => {
        :action => "New Component Type",
        :title => "New Component Type",
        :header => "Create a Component Type"
      },
      :show => {
        :action => "View Component Type",
        :title => "View Component Type",
        :header => "View a Component Type"
      },
      :field_name => {
        :id => 'ID',
        :description => 'Description',
        :sort_order => 'Sort Order',
        :has_costs => 'Has Costs',
        :has_hours => 'Has Hours',
        :has_vendor => 'Has Vendor',
        :has_misc => 'Has Misc',
        :no_entry => 'No Entry',
        :deactivated => 'Deactivated'
      },
      :field_name_short => {
        :id => 'ID',
        :description => 'Description',
        :sort_order => 'Sort',
        :has_costs => 'Costs?',
        :has_hours => 'Hours?',
        :has_vendor => 'Vendor?',
        :has_misc => 'Misc?',
        :no_entry => 'No Entry',
        :deactivated => 'Deact.'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table)',
        :description => 'Description',
        :sort_order => 'Sort Order',
        :has_costs => 'Has Costs',
        :has_hours => 'Has Hours',
        :has_vendor => 'Has Vendor (Keep track of vendor. Unused.)',
        :has_misc => 'Has Misc (Has Misc costs ??)',
        :no_entry => 'No Entry (Used for calculated fields.)',
        :deactivated => 'Deactivated'
      },
      :messages => {
      }
    }, # end ComponentType Resource
    # Component Resource
    :components => {
      :title => 'Components',
      :system => 'estimmaint',
      :menu => {
        :action => "Components Actions Menu",
        :title => "Estimation Components Action Menu",
        :header => "Estimation Components Action Menu"
      },
      :index => {
        :action => "List Components by Type",
        :title => "List Estimation Components by Component Type",
        :header => "List of all Estimation Components by Component Type"
      },
      :list => {
        :action => "List Components by Description",
        :title => "List Estimation Components in Description Order",
        :header => "List of all Estimation Components in Description Order"
      },
      :edit => {
        :action => "Edit Component",
        :title => "Edit Component",
        :header => "Edit a Component"
      },
      :new => {
        :action => "New Component",
        :title => "New Component",
        :header => "Create a Component"
      },
      :show => {
        :action => "View Component",
        :title => "View Component",
        :header => "View a Component"
      },
      :field_name => {
        :id => 'ID',
        :component_type_id => 'Component Type ID',
        :component_type => 'Component Type',
        :description => 'Description',
        :default_id => 'Default ID',
        :default => 'Default Value',
        :calc_only => 'Calculated using Default',
        :deactivated => 'Deactivated',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :component_type_id => 'Comp. Type ID',
        :component_type => 'Comp. Type',
        :description => 'Desc.',
        :default_id => 'Default ID',
        :default => 'Default Value',
        :calc_only => 'Calc. of Default',
        :deactivated => 'Deactivated',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :component_type_id => 'ID of the Component Type this belongs to.',
        :component_type => 'The Component Type this belongs to.',
        :description => 'Description.',
        :default_id => 'ID of the Default Value for this item.',
        :default => 'The Default Value for this item.',
        :calc_only => 'Calculated using Default Value (with no Value change allowed).',
        :deactivated => 'Is this field deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end Component Resource
    # Assemblies Resource
    :assemblies => {
      :title => 'Assemblies',
      :system => 'estimmaint',
      :menu => {
        :action => "Assemblies Actions Menu",
        :title => "Estimation Assemblies Action Menu",
        :header => "Estimation Assemblies Action Menu"
      },
      :index => {
        :action => "List Assemblies in Sort Order",
        :title => "List Estimation Assemblies in Sort Order",
        :header => "List of all Estimation Assemblies in Sort Order"
      },
      :list => {
        :action => "List Assemblies by Description",
        :title => "List Estimation Assemblies in Description Order",
        :header => "List of all Estimation Assemblies in Description Order"
      },
      :edit => {
        :action => "Edit Assembly",
        :title => "Edit Assembly",
        :header => "Edit a Assembly"
      },
      :new => {
        :action => "New Assembly",
        :title => "New Assembly",
        :header => "Create a Assembly"
      },
      :show => {
        :action => "View Assembly",
        :title => "View Assembly",
        :header => "View a Assembly"
      },
      :field_name => {
        :id => 'ID',
        :description => 'Description',
        :sort_order => 'Sort Order',
        :required => 'Required?',
        :deactivated => 'Deactivated?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :description => 'Description',
        :sort_order => 'Sort Order',
        :required => 'Required?',
        :deactivated => 'Deactivated?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :description => 'Description.',
        :sort_order => 'Sort Order',
        :required => 'Is this field required?',
        :deactivated => 'Is this field deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end Assembly Resource
      # AssemblyComponent Resource
    :assembly_components => {
      :title => 'Assembly Component',
      :system => 'estimmaint',
      :menu => {
        :action => "Assembly Components Actions Menu",
        :title => "Estimation Assembly Components Action Menu",
        :header => "Estimation Assembly Components Action Menu"
      },
      :index => {
        :action => "List Assembly Components by Assembly",
        :title => "List Assembly Components by Assembly ",
        :header => "List of all Assembly Components by Assembly "
      },
      :list => {
        :action => "List Assembly Components by Description",
        :title => "List Assembly Components in Description Order",
        :header => "List of all Assembly Components in Description Order"
      },
      :edit => {
        :action => "Edit Assembly Component",
        :title => "Edit Assembly Component",
        :header => "Edit an Assembly Component"
      },
      :new => {
        :action => "New Assembly Component",
        :title => "New Assembly Component",
        :header => "Create an Assembly Component"
      },
      :show => {
        :action => "View Assembly Component",
        :title => "View Assembly Component",
        :header => "View an Assembly Component"
      },
      :field_name => {
        :id => 'ID',
        :assembly_id => 'Assembly ID',
        :assembly => 'Assembly',
        :component_id => 'Component ID',
        :component => 'Component',
        :description => 'Override Component Description',
        :sort_order => 'Sort Order',
        :required => 'Required',
        :deactivated => 'Deactivated',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :assembly_id => 'Assembly ID',
        :assembly => 'Assembly',
        :component_id => 'Component ID',
        :component => 'Component',
        :description => 'Desc.',
        :sort_order => 'Sort',
        :required => 'Req.',
        :deactivated => 'Deact.',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :assembly_id => 'ID of the Assembly this belongs to.',
        :assembly => 'The Assembly this belongs to.',
        :component_id => 'ID of the Component for this.',
        :component => 'The Component for this.',
        :description => 'Use this Description instead of the default Component Description.',
        :sort_order => 'Sort Order',
        :required => 'Is this field required?',
        :deactivated => 'Is this field deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end AssemblyComponent Resource
    :sales_reps => {
      :title => 'Sales Representatives',
      :system => 'estimmaint',
      :menu => {
        :action => "Sales Representatives Actions Menu",
        :title => "Estimation Sales Representatives Action Menu",
        :header => "Estimation Sales Representatives Action Menu"
      },
      :index => {
        :action => "List Sales Representatives",
        :title => "List Sales Representatives",
        :header => "List of all Sales Representatives"
      },
      :list => {
        :action => "List Sales Representatives",
        :title => "List Sales Representatives ",
        :header => "List of all Sales Representatives"
      },
      :edit => {
        :action => "Edit Sales Representative",
        :title => "Edit Sales Representative",
        :header => "Edit an Sales Representative"
      },
      :new => {
        :action => "New Sales Representative",
        :title => "New Sales Representative",
        :header => "Create an Sales Representative"
      },
      :show => {
        :action => "View Sales Representative",
        :title => "View Sales Representative",
        :header => "View an Sales Representative"
      },
      :field_name => {
        :id => 'ID',
        :user_id => 'User ID',
        :user => 'User',
        :min_markup_pct => 'Minimum Markup Percent',
        :max_markup_pct => 'Maximum Markup Percent',
        :deactivated => 'Deactivated',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :user_id => 'User ID',
        :user => 'User',
        :min_markup_pct => 'Min. Markup %',
        :max_markup_pct => 'Max. Markup %',
        :deactivated => 'Deact.',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :user_id => 'User ID (identifier of the user for this salesperson)',
        :user => 'User (the user for this salesperson)',
        :min_markup_pct => 'Minimum Markup Percent this salesperson can adjust by',
        :max_markup_pct => 'Maximum Markup Percent this salesperson can adjust by',
        :deactivated => 'Is this field deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end Sales Rep Resource
    :job_types => {
      :title => 'Job Taxability Types',
      :system => 'estimmaint',
      :menu => {
        :action => "Job Taxability Types Actions Menu",
        :title => "Estimation Job Taxability Types Action Menu",
        :header => "Estimation Job Taxability Types Action Menu"
      },
      :index => {
        :action => "List Job Taxability Types",
        :title => "List Job Taxability Types",
        :header => "List of all Job Taxability Types"
      },
      :list => {
        :action => "List Job Taxability Types",
        :title => "List Job Taxability Types ",
        :header => "List of all Job Taxability Types"
      },
      :edit => {
        :action => "Edit Job Taxability Type",
        :title => "Edit Job Taxability Type",
        :header => "Edit an Job Taxability Type"
      },
      :new => {
        :action => "New Job Taxability Type",
        :title => "New Job Taxability Type",
        :header => "Create an Job Taxability Type"
      },
      :show => {
        :action => "View Job Taxability Type",
        :title => "View Job Taxability Type",
        :header => "View an Job Taxability Type"
      },
      :field_name => {
        :id => 'ID',
        :name => 'Name',
        :description => 'Description',
        :sort_order => 'Sort Order',
        :deactivated => 'Deactivated',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :name => 'Name',
        :description => 'Descr.',
        :sort_order => 'Sort Order',
        :deactivated => 'Deact.',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :name => 'Sales Rep Name',
        :description => 'Description of areas of focus or territories',
        :sort_order => 'Sort Order',
        :deactivated => 'Is this field deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end Job Types Resource
    :states => {
      :title => 'States',
      :system => 'estimmaint',
      :menu => {
        :action => "States Actions Menu",
        :title => "Estimation States Action Menu",
        :header => "Estimation States Action Menu"
      },
      :index => {
        :action => "List States",
        :title => "List States",
        :header => "List of all States"
      },
      :list => {
        :action => "List States by Code",
        :title => "List States by Code",
        :header => "List of all States by Code"
      },
      :edit => {
        :action => "Edit State",
        :title => "Edit State",
        :header => "Edit an State"
      },
      :new => {
        :action => "New State",
        :title => "New State",
        :header => "Create an State"
      },
      :show => {
        :action => "View State",
        :title => "View State",
        :header => "View an State"
      },
      :field_name => {
        :id => 'ID',
        :code => 'Code',
        :name => 'Name',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :code => 'Code',
        :name => 'Name',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :code => 'Code',
        :name => 'Name',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    } # end State Resource
  } # end en
} #end localizations
