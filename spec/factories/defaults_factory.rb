FactoryGirl.define do
  
  sequence :default_name do |n|
    "DefaultName#{n}"
  end
  sequence :default_value do |n|
    BigDecimal.new("#{n}+.1")
  end 
  factory :default, :class => Default do
    store       'Test Store'
    name        {FactoryGirl.generate(:default_name)}
    value       {FactoryGirl.generate(:default_value)}
  end
  factory :default_min, :class => Default do
    store       'Test Store'
    name        {FactoryGirl.generate(:default_name)}
  end    
  factory :default_accessible, :class => Default do
    store         'Test Store Changed'
    name          {FactoryGirl.generate(:default_name)}
    value         {FactoryGirl.generate(:default_value)}
    deactivated   true
  end    
end
