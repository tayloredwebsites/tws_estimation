FactoryGirl.define do
  
  factory :user_session, :class => UserSession do
    username  'TestUser'
    password  'test'
  end
  factory :invalid_user_session, :class => UserSession do
    username  'TestUser'
    password  'invalid'
  end
 
  factory :reg_user_session, :class => UserSession do
    username  'RegUser'
    password  'testr'
  end
  factory :invalid_reg_user_session, :class => UserSession do
    username  'RegUser'
    password  'invalid'
  end
 
  factory :admin_user_session, :class => UserSession do
    username  'AdminUser'
    password  'testa'
  end
  factory :invalid_admin_user_session, :class => UserSession do
    username  'AdminUser'
    password  'invalid'
  end
  
end
