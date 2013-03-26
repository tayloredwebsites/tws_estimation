FactoryGirl.define do
  
  sequence :component_type_description do |n|
    "ComponentType#{n-1}"
  end
  sequence :sort_order do |n|
    n*100
  end
  factory :component_type, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    in_totals_grid    true
  end
  factory :component_type_min, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
  end    
  factory :component_type_accessible, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_costs         false
    has_hours         true
    has_vendor        true
    has_totals        false
    in_totals_grid    false
    deactivated       true
  end    
  factory :component_type_hourly, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_hours        true
  end    
  factory :component_type_totals, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_totals        true
  end    
  factory :component_type_not_in_totals_grid, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    in_totals_grid    false
  end    
  factory :component_type_hours, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_hours         true
    in_totals_grid    true
  end    
end
