FactoryGirl.define do
  
  sequence :description do |n|
    "description_#{n}"
  end
  sequence :sort_order do |n|
    n*100
  end
  factory :component_types, :class => ComponentType do
    description        {Factory.next(:description)}
    sort_order        {Factory.next(:sort_order)}
  end
  factory :component_types_min, :class => ComponentType do
    description        {Factory.next(:description)}
  end    
  factory :component_types_accessible, :class => ComponentType do
    description        {Factory.next(:description)}
    sort_order        {Factory.next(:sort_order)}
    has_costs         false
    has_hours         true
    has_vendor        true
    has_misc          true
    no_entry          true
    deactivated       true
  end    
end
