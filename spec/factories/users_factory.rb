FactoryGirl.define do

  sequence :email do |n|
    "user_#{n}@me.com"
  end
  sequence :username do |n|
    "username#{n}"
  end
  sequence :last_name do |n|
    "LastName#{n}"
  end
  sequence :first_name do |n|
    "FirstName#{n}"
  end

  factory :user, :class => User do
    email       {FactoryGirl.generate(:email)}
    username    {FactoryGirl.generate(:username)}
    first_name  {FactoryGirl.generate(:first_name)}
    last_name   {FactoryGirl.generate(:last_name)}
  end

  factory :user_create, :class => User do
    email       {FactoryGirl.generate(:email)}
    username    {FactoryGirl.generate(:username)}
    first_name  {FactoryGirl.generate(:first_name)}
    last_name   {FactoryGirl.generate(:last_name)}
    password              'test'
    password_confirmation 'test'
  end

  factory :user_min_attr, :class => User do
    email     'email@example.com'
    username  'TestUser'
  end
  factory :user_min_create_attr, :class => User do
    email     'email@example.com'
    username  'TestUser'
    password              'test'
    password_confirmation 'test'
  end
  factory :user_full_create_attr, :class => User do
    first_name      'Test'
    last_name       'User'
    email     'email@example.com'
    username  'TestUser'
    roles     DEFAULT_ROLES.join(' ')
    password              'test'
    password_confirmation 'test'
  end
  factory :user_update_password_attr, :class => User do
    email     'email@example.com'
    username              'TestUser'
    old_password          'test'
    password              'new_pass'
    password_confirmation 'new_pass'
  end

  factory :user_roles_attr, :class => User do
    roles           'all_guests maint_users'
  end
  factory :user_safe_attr, :class => User do
    first_name      'Test'
    last_name       'User'
    email           'email2@example.com'
    username        'TestUser2'
  end
  factory :user_unsafe_attr, :class => User do
    admin          'true'
  end
  factory :user_inval_attr, :class => User do
    admin       'true'
    foo         'true'
    bar         'true'
  end

  factory :reg_user_min_attr, :class => User do
    email     'reguser@example.com'
    username  'RegUser'
  end
  factory :reg_user_min_create_attr, :class => User do
    email     'reguser@example.com'
    username  'RegUser'
    password              'testr'
    password_confirmation 'testr'
  end
  factory :reg_user_full_create_attr, :class => User do
    first_name      'Regular'
    last_name       'User'
    email     'reguser@example.com'
    username  'RegUser'
    roles     DEFAULT_ROLES.join(' ')+' maint_users estim_users'
    password              'testr'
    password_confirmation 'testr'
  end
  factory :reg_user_update_password_attr, :class => User do
    email     'reguser@example.com'
    username  'RegUser'
    old_password          'testr'
    password              'new_pass'
    password_confirmation 'new_pass'
  end

  factory :admin_user_min_attr, :class => User do
    email     'admin@example.com'
    username  'AdminUser'
  end
  factory :admin_user_min_create_attr, :class => User do
    email     'admin@example.com'
    username  'AdminUser'
    password              'testa'
    password_confirmation 'testa'
  end
  factory :admin_user_full_create_attr, :class => User do
    first_name      'Admin'
    last_name       'User'
    email     'admin@example.com'
    username  'AdminUser'
    roles     DEFAULT_ROLES.join(' ')+' all_admins'
    password              'testa'
    password_confirmation 'testa'
  end
  factory :admin_user_update_password_attr, :class => User do
    email     'admin@example.com'
    username  'AdminUser'
    old_password          'testa'
    password              'new_pass'
    password_confirmation 'new_pass'
  end

end
