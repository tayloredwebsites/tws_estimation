FactoryGirl.define do
  
  factory :user_min_attr, :class => User do
    email     'email@example.com'
    username  'TestUser'
    
    factory :user_min_create_attr do
      password              'test'
      password_confirmation 'test'
    end
    
  end
  
end
