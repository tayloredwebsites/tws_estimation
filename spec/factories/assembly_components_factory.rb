# Read about factories at https://github.com/thoughtbot/factory_girl

# return all attributes for create, for later comparison in tests
def generate_assembly_component_accessible_attributes
  assembly = FactoryGirl.create(:assembly_create)
  component_type = FactoryGirl.create(:component_type_accessible)
  default_hourly = Default.create!(FactoryGirl.attributes_for(:default, :value => 22.75))
  component = FactoryGirl.create(:component_min_create, :component_type => component_type, labor_rate_default: default_hourly)
  return {
    :assembly_id => assembly.id,
    :description => FactoryGirl.generate(:assembly_component_description),
    :component_id => component.id,
    :required => false,
    :deactivated => false
  }
end
  
# return minimum attributes required to create, for later comparison in tests
def generate_assembly_component_min_attributes
  assembly = FactoryGirl.create(:assembly_create)
  component_type = FactoryGirl.create(:component_type_accessible)
  default_hourly = Default.create!(FactoryGirl.attributes_for(:default, :value => 22.75))
  component = FactoryGirl.create(:component_min_create, :component_type => component_type, labor_rate_default: default_hourly)
  return {
    :assembly_id => assembly.id,
    # :description => FactoryGirl.generate(:assembly_component_description),
    :component_id => component.id
    # :required => false,
    # :deactivated => false
  }
end
  
FactoryGirl.define do
  sequence :assembly_component_description do |n|
    "AssemblyComponentDescription#{n-1}"
  end
  # standard fields used to create an item
  factory :assembly_component_create, :class => AssemblyComponent do
    association :assembly,  :factory => :assembly,  :strategy => :build
    association :component, :factory => :component, :strategy => :build
    description {FactoryGirl.generate(:assembly_component_description)}
    required false
    deactivated false
  end
  factory :assembly_component_hourly_create, :class => AssemblyComponent do
    association :assembly,  :factory => :assembly,  :strategy => :build
    association :component, :factory => :component_hourly_create, :strategy => :build
    description {FactoryGirl.generate(:assembly_component_description)}
    required false
    deactivated false
  end
  factory :assembly_component_min_create, :class => AssemblyComponent do
    association :assembly,  :factory => :assembly,  :strategy => :build
    association :component, :factory => :component_min_create, :strategy => :build
    description {FactoryGirl.generate(:assembly_component_description)}
    required false
    deactivated false
  end    
  factory :assembly_component_totals_create, :class => AssemblyComponent do
    association :assembly,  :factory => :assembly,  :strategy => :build
    association :component, :factory => :component_totals_create, :strategy => :build
    description {FactoryGirl.generate(:assembly_component_description)}
    required false
    deactivated false
  end    
  factory :assembly_component_accessible, :class => AssemblyComponent do
    description             'My Description'
    required true
    deactivated true
  end
  factory :assembly_component_accessible_create, :class => AssemblyComponent do
    association :assembly,  :factory => :assembly,  :strategy => :build
    association :component, :factory => :component, :strategy => :build
    description             'My Description'
    required true
    deactivated true
  end
end
