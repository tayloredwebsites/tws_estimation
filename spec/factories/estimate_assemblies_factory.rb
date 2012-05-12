# Read about factories at https://github.com/thoughtbot/factory_girl

# return all attributes for create, for later comparison in tests
def generate_estimate_assembly_accessible_attributes(user_id = nil)
  estimate = Estimate.new(generate_estimate_min_attributes(user_id))
  assembly = Estimate.new(FactoryGirl.attributes_for(:assembly_create))
  return {
    :estimate_id => estimate.id,
    :assembly_id => assembly.id,
    :deactivated => false
  }
end

# return minimum attributes required to create, for later comparison in tests
def generate_estimate_assembly_min_attributes(user_id = nil)
  estimate = Estimate.new(generate_estimate_min_attributes(user_id))
  assembly = Estimate.new(FactoryGirl.attributes_for(:assembly_create))
  return {
    :estimate_id => estimate.id,
    :assembly_id => assembly.id
  }
end

FactoryGirl.define do
  sequence :estimate_assembly_description do |n|
    "Description#{n}"
  end
  # standard fields used to create an item
  factory :estimate_assembly, :class => EstimateAssembly do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly,  :strategy => :build
    deactivated false
  end
  factory :estimate_assembly_min_create, :class => EstimateAssembly do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly,  :strategy => :build
    deactivated false
  end
  factory :estimate_assembly_accessible_create, :class => EstimateAssembly do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly,  :strategy => :build
    deactivated true
  end    
  factory :estimate_assembly_accessible, :class => EstimateAssembly do
    deactivated true
  end    
end
