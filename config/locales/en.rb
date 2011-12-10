# config/locales/en.rb
# localization file using ruby hash method (instead of yaml).
{
  :en => {
    :config => {
      :company_name => 'Taylored Web Sites',
      :company_email => 'tayloredwebsites@me.com',
      :app_name => 'TWS Rails Startup App',
      :app => 'tws_auth'
    },
    :systems => {
      :all => {
        :abbreviation => 'All',
        :full_name => 'All Systems',
        :actual => 'false'
      },
      :maint => {
        :abbreviation => 'Maint',
        :full_name =>'Application Maintenance',
        :actual => 'true'
      },
      :estim => {
        :abbreviation => 'Estim',
        :full_name => 'Estimation',
        :actual => 'true'
      },
      :prevail => {
        :abbreviation => 'Prevail',
        :full_name =>'Prevailing wages',
        :actual => 'true'
      }
    },
    :roles => {
      :guests => {
        :abbreviation => 'Guest',
        :full_name => 'Guest'
      },
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
      :sure_action_name? => 'Are you sure you want to %{action} %{name}?'
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
      :access_denied_msg => "Access Denied! %{msg}",
      :active_record_error_msg => "Active Record Error! %{msg}",
      :msg => "%{msg}"
    },
    :error_messages => {
      :is_active => 'is an active record.',
      :is_deactivated => 'is a deactivated record.',
      :got_error => 'got an error.',
      :missing_password => 'missing password',
      :password_mismatch => 'passwords mismatched',
      :no_password_update => 'cannot update password here',
      :invalid_password => 'invalid username or password',
      :check_email => 'check your email for next step'
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
      :welcome_user => 'Welcome %{user}'
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
      :delete => 'Delete'
    },
    # :index_title => 'List', # use :view_action.list or :users.index.title
    # :edit_title => 'Edit', # use :view_action.edit or :users.edit.title
    # :new_title => 'New', # use :view_action.new or :users.new.title
    # :show_title => 'View', # use :view_action.show or :users.show.title
    :home => {
      :index => {
        :title => "Home",
        :header => "Controlled Air Systems"
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
        :header => "Errors page (unrecoverable errors)"
      }
    }, # end home
    :users => {
      :title => 'Users',
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
        :session_timeout => 'Your session has timed out',
        :invalid_role => "Invalid role %{role}"
      }
    }, # end users
    :users_sessions => {
      :title => 'User Sessions',
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
    } # end users
  } # end en
} #end localizations
