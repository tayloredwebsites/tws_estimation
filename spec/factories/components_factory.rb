# Read about factories at https://github.com/thoughtbot/factory_girl


# return all attributes for create, for later comparison in tests
def generate_component_accessible_attributes
  component_type = FactoryGirl.create(:component_type_accessible)
  default = FactoryGirl.create(:default_accessible)
  default_hourly_rate = FactoryGirl.create(:default_accessible)
  return {
    :component_type_id => component_type.id,
    :description => FactoryGirl.generate(:component_description),
    :default_id => default.id,
    :editable => false,
    :deactivated => false,
    :grid_operand => '%',
    :grid_scope => 'A',
    :grid_subtotal => 'First',
    :labor_rate_default_id => default_hourly_rate.id,
    :types_in_calc => ''
  }
end

# return minimum attributes required to create, for later comparison in tests
def generate_component_min_attributes
  component_type = FactoryGirl.create(:component_type_accessible)
  default = FactoryGirl.create(:default_accessible)
  return {
    :component_type_id => component_type.id,
    :description => FactoryGirl.generate(:component_description)
  }
end

FactoryGirl.define do
  sequence :component_description do |n|
    "Description#{n-1}"
  end
  factory :component, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    association             :default, :factory => :default, :strategy => :build
  end
  factory :component_create, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    association             :default, :factory => :default, :strategy => :build
  end
  factory :component_hourly_create, :class => Component do
    association             :component_type, :factory => :component_type_hourly, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    association             :default, :factory => :default, :strategy => :build
    association             :labor_rate_default, :factory => :default, :strategy => :build
  end
  factory :component_min_create, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    default_id              nil
    association             :labor_rate_default, :factory => :default, :strategy => :build
  end
  factory :component_totals_create, :class => Component do
    association             :component_type, :factory => :component_type_totals, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    # association             :default, :factory => :default, :strategy => :build
    default_id              nil
  end
  factory :component_totals_editable_create, :class => Component do
    association             :component_type, :factory => :component_type_totals, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    # association             :default, :factory => :default, :strategy => :build
    default_id              nil
    editable                true
  end
  factory :component_in_totals_grid_create, :class => Component do
    association             :component_type, :factory => :component_type_in_totals_grid, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    association             :default, :factory => :default, :strategy => :build
  end
  factory :component_accessible, :class => Component do
    description             'Changed Description'
    editable               true
    deactivated             true
    grid_operand              '%'
    grid_scope                'A'
    grid_subtotal          'First'
    types_in_calc           ''
  end
  factory :component_accessible_create, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             'Changed Description'
    editable               true
    deactivated             true
    # grid_operand              '%'
    # grid_scope                'A'
    # grid_subtotal          'First'
  end
end
