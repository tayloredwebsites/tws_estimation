# config/locales/en.rb
# localization file using ruby hash method (instead of yaml).
{
  :en => {
    :config => {
      :company_name => 'Controlled Air',
      :app_name => 'Controlled Air Systems'
    },
    :errors => {
      :sure? => 'Are you sure?',
      :cannot_find_obj => "Cannot find %{obj}",
      :cannot_find_obj_id => "Cannot find %{obj} with ID %{id}",
      :invalid_record_obj => "Invalid record for %{obj}",
      :invalid_record_obj_id => "Invalid record for %{obj} with ID %{id}",
      :success_method_obj_id => "Successful %{method} of %{obj} with ID %{id}",
      :success_method_obj_name => "Successful %{method} of %{obj} %{name}",
      :success_method => "Successful %{method}",
      :cannot_method_obj_id => "Cannot %{method} of %{obj} with ID %{id}",
      :cannot_method_msg => "Cannot %{method} - %{msg}"
    },
    :error_messages => {
      :is_active => 'is an active record.',
      :is_deactivated => 'is a deactivated record.',
      :got_error => 'got an error.',
    },
    :view_text => {
      :true => 'truly',
      :false => 'not',
      :deactivate => 'Deactivate',
      :reactivate => 'Reactivate',
      :destroy => 'Destroy',
      :delete => 'Delete',
      :index_title => 'List',
      :edit_title => 'Edit',
      :new_title => 'New',
      :show_title => 'View'
    },
    :company_name => 'Controlled Air',
    :app_name => 'Controlled Air Systems',
    :index_title => 'List',
    :edit_title => 'Edit',
    :new_title => 'New',
    :show_title => 'View',
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
      }
    } # end users
  } # end en
} #end localizations
