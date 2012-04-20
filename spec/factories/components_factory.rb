# Read about factories at https://github.com/thoughtbot/factory_girl


def generate_component_accessible_attributes
  component_type = FactoryGirl.create(:component_type_accessible)
  default = FactoryGirl.create(:default_accessible)
  return {
    :component_type_id => component_type.id,
    :description => FactoryGirl.generate(:component_description),
    :default_id => default.id,
    :calc_only => false,
    :deactivated => false
  }
end
  
def generate_component_min_attributes
  component_type = FactoryGirl.create(:component_type_accessible)
  default = FactoryGirl.create(:default_accessible)
  return {
    :component_type_id => component_type.id,
    :description => FactoryGirl.generate(:component_description),
  }
end
  
FactoryGirl.define do
  sequence :component_description do |n|
    "Description#{n}"
  end
  factory :component_create, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    association             :default, :factory => :default, :strategy => :build
  end
  factory :component_min_create, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             {FactoryGirl.generate(:component_description)}
    default_id              nil
  end    
  factory :component_accessible, :class => Component do
    description             'Changed Description'
    calc_only               true
    deactivated             true
  end
  factory :component_accessible_create, :class => Component do
    association             :component_type, :factory => :component_type, :strategy => :build
    description             'Changed Description'
    calc_only               true
    deactivated             true
  end
end
