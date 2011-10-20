# config/locales/en.rb
# localization file using ruby hash method (instead of yaml).
{
  :en => {
    :config => {
      :company_name => 'Taylored Web Sites',
      :company_email => 'tayloredwebsites@me.com',
      :app_name => 'User Auth Base Application'
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
      :success_method => "Successful %{method}",
      :cannot_method_obj_id => "Cannot %{method} of %{obj} with ID %{id}",
      :cannot_method_msg => "Cannot %{method} - %{msg}",
      :invalid_call => 'invalid call to %{method}'
    },
    :error_messages => {
      :is_active => 'is an active record.',
      :is_deactivated => 'is a deactivated record.',
      :got_error => 'got an error.',
      :missing_password => 'missing password',
      :password_mismatch => 'passwords mismatched',
      :no_password_update => 'cannot update password here',
      :invalid_password => 'invalid username/password'
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
      :delete => 'Delete',
      :update_password => 'Update Password!',
      :login => 'Log In',
      :logout => 'Log Out'
    },
    :company_name => 'Controlled Air',
    :app_name => 'Controlled Air Systems',
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
        :title => "List Users",
        :header => "List of all users"
      },
      :edit => {
        :title => "Edit User",
        :header => "Edit a user"
      },
      :new => {
        :title => "New User",
        :header => "Create a new User"
      },
      :show => {
        :title => "View User",
        :header => "View a user"
      },
      :edit_password => {
        :title => "Edit Password",
        :header => "Edit your User Password "
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
      }
    }, # end users
    :sessions => {
      :title => 'Sessions',
      :signin => {
        :title => "Login",
        :header => "Login"
      },
      :create => {
        :title => "Logged In",
        :header => "Logged in"
      },
      :signout => {
        :title => "Logged Out",
        :header => "Logged out"
      },
      :field_name => {
        :username => 'Username',
        :password => 'Password'
      },
      :field_name_short => {
        :username => 'Username',
        :password => 'Password'
      }
    } # end users
  } # end en
} #end localizations
