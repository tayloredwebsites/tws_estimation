FactoryGirl.define do
  
  sequence :default_name do |n|
    "default_name_#{n}"
  end
  sequence :default_value do |n|
    n
  end 
  factory :defaults, :class => Default do
    store       'Test Store'
    name        {Factory.next(:default_name)}
    value       {Factory.next(:default_value)}
  end
  factory :defaults_min, :class => Default do
    store       'Test Store'
    name        {Factory.next(:default_name)}
  end    
end
