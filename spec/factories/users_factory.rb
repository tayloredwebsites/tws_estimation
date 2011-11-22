FactoryGirl.define do
  
  sequence :email do |n|
    "user_#{n}@me.com"
  end
  sequence :username do |n|
    "username_#{n}"
  end
  
  factory :users, :class => User do
    email       {Factory.next(:email)}
    username    {Factory.next(:username)}
  end
  
  factory :users_create, :class => User do
    email       {Factory.next(:email)}
    username    {Factory.next(:username)}
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
    password              'testa'
    password_confirmation 'testa'
  end
  
end
