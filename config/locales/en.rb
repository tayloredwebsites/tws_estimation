# config/locales/en.rb
# localization file using ruby hash method (instead of yaml).
{
  :en => {
    # general user displays
    :config => {
      :company_name => 'Taylored Web Sites',
      :company_email => 'tayloredwebsites@me.com',
      :app_name => 'Estimation of assembly/component costs',
      :app => 'tws_estimation'  # not used so far
    },
    # these are the Left Menu item descriptions.  Top level is the MenuItems.each[:app_id].  below represents the menu tree structure
    :menu_items => {
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
          :users => 'Users',
          :edit_password => 'Edit My Password'
        }
      },
      :estim => {
        :abbreviation => 'Estimation',
        :full_name => 'Estimation',
        :menu_items => {
          :estim_admin => {
            :abbreviation => 'Estimate Administration',
            :full_name => 'Estimate Administration',
            :menu_items => {
              :estimates_index => 'Estimates by Sales Rep',
              :estimates_list => 'Estimates by Title',
              :estimates_new => 'New Estimate'
            }
          },
          :estim_list => 'Estimates Listing by Title',
          :estim_new => 'New Estimate',
          :defaults => 'Defaults',
          :component_types => 'Component Types',
          :components => {
            :abbreviation => 'Components',
            :full_name => 'Components',
            :menu_items => {
              :components_index => 'Components by Type',
              :components_list => 'Components Description'
          } },
          :assemblies => {
            :abbreviation => 'Assemblies',
            :full_name => 'Assemblies',
            :menu_items => {
              :assemblies_index => 'Assemblies in Sort Order',
              :assemblies_list => 'Assemblies by Description'
          } },
          :assembly_components => {
            :abbreviation => 'Assembly Components',
            :full_name => 'Assembly Components',
            :menu_items => {
              :assembly_components_index => 'Assembly Components by Assembly',
              :assembly_components_list => 'Assembly Components by Description'
          } },
          :sales_reps => 'Sales Reps',
          :job_types => 'Job Taxability Types',
          :states => 'States',
          :estimates => {
            :abbreviation => 'Estimates',
            :full_name => 'Estimates',
            :menu_items => {
              :estimates_index => 'Estimates by Sales Rep',
              :estimates_list => 'Estimates by Title'
          } }
        }
      },
      :maintuser => {
        :abbreviation => 'Maint.',
        :full_name => 'Maintenance',
        :menu_items => {} # see estim entry (this is for titles of systems with mutiple nav items)
      },
      :estimuser => {
        :abbreviation => 'Estim. Entry',
        :full_name => 'Estimation Entry',
        :menu_items => {} # see estim entry (this is for titles of systems with mutiple nav items)
      },
      :estimadmin => {
        :abbreviation => 'Estim. Entry',
        :full_name => 'Estimation Entry',
        :menu_items => {} # see estim entry (this is for titles of systems with mutiple nav items)
      },
      :estimmaint => {
        :abbreviation => 'Estim. Maint.',
        :full_name => 'Estimation Maintenance',
        :menu_items => {} # see estim entry (this is for titles of systems with mutiple nav items)
      },
      :prevail => {
        :abbreviation => 'Prevail',
        :full_name => 'Prevailing Wages',
        :menu_items => {}
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
    :systems => {
      :all => {
        :abbreviation => 'All',
        :full_name => 'All Systems'
      },
      :guest => {
        :abbreviation => 'Guest',
        :full_name => 'System Guest'
      },
      :maint => {
        :abbreviation => 'Maint.',
        :full_name => 'System Maintenance'
      },
      :estim => {
        :abbreviation => 'Estim.',
        :full_name => 'Estimation System'
      },
      :prevail => {
        :abbreviation => 'Prevail.',
        :full_name => 'Prevailing Wages System'
      }
    },
    :warning => {
      :sure? => 'Are you sure?',
      :sure_action? => 'Are you sure you want to %{action}?',
      :sure_action_name? => 'Are you sure you want to %{action} %{name}?',
      :sure_action_id? => 'Are you sure you want to %{action} item with ID: %{id}?',
      :hrs_unconverted => ' ( * %{hrs} Unconverted Hours)'
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
      :warn_method_obj_name_warn => "WARNING: %{method} of %{obj} %{name} successful, but with warning: %{warn}",
      :cannot_method_obj_id => "Cannot %{method} %{obj} with ID %{id}",
      :cannot_method_obj_name => "Cannot %{method} %{obj} %{name}",
      :cannot_method_obj_msg => "Cannot %{method} %{obj} - %{msg}",
      :cannot_method_msg => "Cannot %{method} - %{msg}",
      :invalid_call => 'invalid call to %{method}',
      :invalid_method_argument => 'Method %{method} has invalid argument %{argument}',
      :missing_msg => "Missing %{msg}",
      :obj_does_not_exist => "%{obj} user does not exist",
      :cannot_method_your_obj => "Cannot %{method} your own %{obj}",
      :access_denied_msg_obj => "Access Denied! You have restrictions on doing a %{msg} of %{obj}",
      :access_denied_msg => "Access Denied! You have restrictions on doing a %{msg}",
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
      :is_not_string => 'is not a string',
      :is_required => 'is required',
      :missing_required_field => 'Required field is missing.',
      :missing_component_scope_operand => 'Component is missing Scope and Operand.',
      :missing_component_operand => 'Component is missing Operand.',
      :missing_component_scope => 'Component is missing Scope.',
      :unconverted_hours => 'Some hours are not converted.',
      :invalid_hourly_conversion => 'Extra hourly conversion'
    },
    :view_field_value => {
      :true => 'truly',
      :false => 'not',
      :deactivated => 'Deactivated',
      :reactivated => 'Active',
      :active => 'Active'
    },
    :view_field_labels => {
      :in_hours => ' hrs.'
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
      :edit_password => 'Edit Password',
      :update => 'Update',
      :update_password => 'Update Password',
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
      :license => {
        :title => "Licensing",
        :header => "This software is distributed under MIT Licensing."
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
        :header => "Edit your User Password"
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
        :has_totals => 'Has Totals',
        :in_totals_grid => 'In Totals Grid',
        :deactivated => 'Deactivated'
      },
      :field_name_short => {
        :id => 'ID',
        :description => 'Description',
        :sort_order => 'Sort',
        :has_costs => 'Costs?',
        :has_hours => 'Hours?',
        :has_vendor => 'Vendor?',
        :has_totals => 'Has Totals Grid',
        :in_totals_grid => 'In Totals Grid',
        :deactivated => 'Deact.'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table)',
        :description => 'Description',
        :sort_order => 'Sort Order',
        :has_costs => 'Has Costs',
        :has_hours => 'Has Hours',
        :has_vendor => 'Has Vendor (Keep track of vendor. Unused.)',
        :has_totals => 'Has Totals Grid, and perform calculations to add to totals.',
        :in_totals_grid => 'Display in Totals Grid for calculations.',
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
        :editable => 'Editable (in Totals Grid)',
        :grid_operand => 'Grid Operand',
        :grid_scope => 'Grid Operand Scope',
        :grid_subtotal => 'Grid Subtotal Group',
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
        :editable => 'Editable',
        :grid_operand => 'Operand',
        :grid_scope => 'Scope',
        :grid_subtotal => 'Subtotal',
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
        :editable => 'Editable (in Totals Grid - allows value change).',
        :grid_operand => 'The calculation to be performed on the value',
        :grid_scope => 'The Scope the operand is to work on',
        :grid_subtotal => 'Name of Grid Subtotal Group',
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
        :title => "List Assembly Components by Assembly",
        :header => "List of all Assembly Components by Assembly"
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
        :action => "Sales Reps Actions Menu",
        :title => "Estimation Sales Representatives Action Menu",
        :header => "Estimation Sales Representatives Action Menu"
      },
      :index => {
        :action => "List Sales Reps by Last Name, First Name",
        :title => "List Sales Representatives by Last Name, First Name",
        :header => "List of all Sales Representatives by Last Name, First Name"
      },
      :list => {
        :action => "List Sales Reps",
        :title => "List Sales Representatives",
        :header => "List of all Sales Representatives"
      },
      :edit => {
        :action => "Edit Sales Rep",
        :title => "Edit Sales Representative",
        :header => "Edit an Sales Representative"
      },
      :new => {
        :action => "New Sales Rep",
        :title => "New Sales Representative",
        :header => "Create an Sales Representative"
      },
      :show => {
        :action => "View Sales Rep",
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
      :title => 'Job Tax Types',
      :system => 'estimmaint',
      :menu => {
        :action => "Job Tax Types Actions Menu",
        :title => "Estimation Job Taxability Types Action Menu",
        :header => "Estimation Job Taxability Types Action Menu"
      },
      :index => {
        :action => "List Job Tax Types in Sort order",
        :title => "List Job Taxability Types in Sort order",
        :header => "List of all Job Taxability Types in Sort order"
      },
      :list => {
        :action => "List Job Tax Types",
        :title => "List Job Taxability Types",
        :header => "List of all Job Taxability Types"
      },
      :edit => {
        :action => "Edit Job Tax Type",
        :title => "Edit Job Taxability Type",
        :header => "Edit an Job Taxability Type"
      },
      :new => {
        :action => "New Job Tax Type",
        :title => "New Job Taxability Type",
        :header => "Create an Job Taxability Type"
      },
      :show => {
        :action => "View Job Tax Type",
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
    }, # end State Resource
    :estimates => {
      :title => 'Estimates',
      :system => 'estimmaint',
      :menu => {
        :action => "Estimates Actions Menu",
        :title => "Estimation Estimates Action Menu",
        :header => "Estimation Estimates Action Menu"
      },
      :index => {
        :action => "List Estimates by Sales Rep",
        :title => "List Estimates by Sales Rep",
        :header => "List of all Estimates by Sales Rep"
      },
      :list => {
        :action => "List Estimates by Title",
        :title => "List Estimates by Title",
        :header => "List of all Estimates by Title"
      },
      :edit => {
        :action => "Edit Estimate",
        :title => "Edit Estimate",
        :header => "Edit an Estimate"
      },
      :new => {
        :action => "New Estimate",
        :title => "New Estimate",
        :header => "Create an Estimate"
      },
      :show => {
        :action => "View Estimate",
        :title => "View Estimate",
        :header => "View an Estimate"
      },
      :field_name => {
        :id => 'ID',
        :title => 'Title',
        :customer_name => 'Customer Name',
        :customer_note => 'Customer Note',
        :sales_rep_id => 'Sales Rep ID',
        :sales_rep => 'Sales Rep',
        :job_type_id => 'Job Type ID',
        :job_type => 'Job Taxability Type',
        :state_id => 'State ID',
        :state => 'State',
        :prevailing_wage => 'Prevailing Wage?',
        :note => 'Note',
        :deactivated => 'Deactivated?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :title => 'Title',
        :customer_name => 'Cust. Name',
        :customer_note => 'Cust. Note',
        :sales_rep_id => 'Sales Rep ID',
        :sales_rep => 'Sales Rep',
        :job_type_id => 'Job Type ID',
        :job_type => 'Job Tax Type',
        :state_id => 'State ID',
        :state => 'State',
        :prevailing_wage => 'Prevail?',
        :note => 'Note',
        :deactivated => 'Deactivated?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :title => 'The Title of this estimate',
        :customer_name => 'The name of the Customer or Prospect for this Estimate',
        :customer_note => 'Any special information about this Customer or Prospect',
        :sales_rep_id => 'The ID of the Sales Rep for this Estimate',
        :sales_rep => 'The Sales Rep for this Estimate',
        :job_type_id => 'The ID of the Job Taxability Type this estimate is',
        :job_type => 'The Job Taxability Type this estimate is',
        :state_id => 'The ID of the state this job is being done',
        :state => 'The state this job is being done',
        :prevailing_wage => 'Is this a prevailing wage Job (for govt. work)?',
        :note => 'Any special information about this Estimate',
        :deactivated => 'Is this record deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end Estimate Resource
    :estimate_assemblies => {
      :title => 'Estimate Assemblies',
      :field_name => {
        :id => 'ID',
        :estimate_id => 'Estimate ID',
        :estimate => 'Estimate',
        :assembly_id => 'Assembly ID',
        :assembly => 'Assembly',
        :selected => 'Selected?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :estimate_id => 'Estimate ID',
        :estimate => 'Estimate',
        :assembly_id => 'Assembly ID',
        :assembly => 'Assembly',
        :selected => 'Selected?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :estimate_id => 'The ID of the Estimate for this assembly',
        :estimate => 'The Estimate for this assembly',
        :assembly_id => 'The ID of this Assembly',
        :assembly => 'This Assembly',
        :selected => 'Is this record selected?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    }, # end EstimateAssemblies Resource
    :estimate_components => {
      :title => 'Estimate Components',
      :field_name => {
        :id => 'ID',
        :estimate_assembly_id => 'Estimate Assembly ID',
        :estimate_assembly => 'Estimate Assembly',
        :assembly_component_id => 'Assembly Component ID',
        :assembly_component => 'Assembly Component',
        :write_in_name => 'Write-in Name',
        :value => 'value',
        :deactivated => 'Deactivated?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_short => {
        :id => 'ID',
        :estimate_assembly_id => 'Estimate Assembly ID',
        :estimate_assembly => 'Estimate Assembly',
        :assembly_component_id => 'Assembly Component ID',
        :assembly_component => 'Assembly Component',
        :write_in_name => 'Write-in Name',
        :value => 'value',
        :deactivated => 'Deactivated?',
        :created_at => 'Created',
        :updated_at => 'Updated'
      },
      :field_name_tip => {
        :id => 'ID (identifier used by database to uniquely idenfify item in table).',
        :estimate_id => 'The ID of the Estimate for this assembly',
        :estimate => 'The Estimate for this assembly',
        :assembly_id => 'The ID of this Assembly',
        :assembly => 'This Assembly',
        :estimate_assembly_id => 'The ID of the Estimate Assembly for this component',
        :estimate_assembly => 'The Estimate Assembly for this component',
        :assembly_component_id => 'The ID of the Assembly Component for this component',
        :assembly_component => 'The Assembly Componentfor this component',
        :write_in_name => 'Write-in Name (will default to component description)',
        :value => 'value (decimal number)',
        :deactivated => 'Deactivated?',
        :created_at => 'Created at this Date and Time.',
        :updated_at => 'Last Updated at this date and time.'
      },
      :messages => {
      }
    } # end EstimateAssemblies Resource
  } # end en
} #end localizations
