# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :component_description do |n|
    "description_#{n}"
  end
  factory :component_create, :class => Component do
    association :component_type, :factory => :component_type, :strategy => :build
    description Factory.next(:component_description)
    association :default, :factory => :defaults, :strategy => :build
  end
  factory :component_min_create, :class => Component do
    association :component_type, :factory => :component_type, :strategy => :build
    description             {Factory.next(:component_description)}
    default_id              nil
  end    
  factory :component_accessible, :class => Component do
    description             'Changed Description'
    calc_only               true
    deactivated             true
  end
  factory :component_accessible_create, :class => Component do
    association :component_type, :factory => :component_type, :strategy => :build
    description             'Changed Description'
    calc_only               true
    deactivated             true
  end
end
