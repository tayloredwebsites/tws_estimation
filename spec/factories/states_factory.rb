# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :state_code do |n|
    "StateCode#{n}"
  end
  sequence :state_name do |n|
    "StateName#{n}"
  end
  factory :state, :class => State do
    code              {FactoryGirl.generate(:state_code)}
    name              {FactoryGirl.generate(:state_name)}
  end
  factory :state_min, :class => State do
    code              {FactoryGirl.generate(:state_code)}
    name              {FactoryGirl.generate(:state_name)}
  end    
  factory :state_accessible, :class => State do
    code              {FactoryGirl.generate(:state_code)}
    name              {FactoryGirl.generate(:state_name)}
  end    
end
