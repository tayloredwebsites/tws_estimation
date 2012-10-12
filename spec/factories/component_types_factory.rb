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
    in_totals_grid    DB_TRUE
  end
  factory :component_type_min, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
  end    
  factory :component_type_accessible, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_costs         DB_FALSE
    has_hours         DB_TRUE
    has_vendor        DB_TRUE
    has_totals        DB_FALSE
    in_totals_grid    DB_FALSE
    deactivated       DB_TRUE
  end    
  factory :component_type_totals, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_totals        DB_TRUE
  end    
  factory :component_type_not_in_totals_grid, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    in_totals_grid    DB_FALSE
  end    
  factory :component_type_hours, :class => ComponentType do
    description       {FactoryGirl.generate(:component_type_description)}
    sort_order        {FactoryGirl.generate(:sort_order)}
    has_hours         DB_TRUE
    in_totals_grid    DB_TRUE
  end    
end
