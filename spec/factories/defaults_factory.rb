FactoryGirl.define do
  
  sequence :default_name do |n|
    "default_name_#{n}"
  end
  sequence :default_value do |n|
    BigDecimal.new("#{n}+.1")
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
  factory :defaults_accessible, :class => Default do
    store         'Test Store Changed'
    name          {Factory.next(:default_name)}
    value         {Factory.next(:default_value)}
    deactivated   true
  end    
end
