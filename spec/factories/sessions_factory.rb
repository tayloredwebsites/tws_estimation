FactoryGirl.define do
  
  factory :user_session, :class => UserSession do
    username  'TestUser'
    password  'test'
    
    factory :invalid_user_session do
      password              'invalid'
    end
    
  end
  
end
