FactoryGirl.define do
  
  sequence :component_type_description do |n|
    "component_type_#{n}"
  end
  sequence :sort_order do |n|
    n*100
  end
  factory :component_type, :class => ComponentType do
    description       {Factory.next(:component_type_description)}
    sort_order        {Factory.next(:sort_order)}
  end
  factory :component_type_min, :class => ComponentType do
    description       {Factory.next(:component_type_description)}
  end    
  factory :component_type_accessible, :class => ComponentType do
    description       {Factory.next(:component_type_description)}
    sort_order        {Factory.next(:sort_order)}
    has_costs         false
    has_hours         true
    has_vendor        true
    has_misc          true
    no_entry          true
    deactivated       true
  end    
end
