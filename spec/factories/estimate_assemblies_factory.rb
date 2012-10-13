# Read about factories at https://github.com/thoughtbot/factory_girl

# return all attributes for create, for later comparison in tests
def generate_estimate_assembly_accessible_attributes()
  estimate = Estimate.create!(generate_estimate_min_attributes())
  assembly = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
  return {
    :estimate_id => estimate.id,
    :assembly_id => assembly.id,
    :selected => false
  }
end

# return minimum attributes required to create, for later comparison in tests
def generate_estimate_assembly_min_attributes()
  estimate = Estimate.create!(generate_estimate_min_attributes())
  assembly = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
  return {
    :estimate_id => estimate.id,
    :assembly_id => assembly.id
  }
end

FactoryGirl.define do
  # standard fields used to create an item
  factory :estimate_assembly, :class => EstimateAssembly do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly_create,  :strategy => :build
    selected false
  end
  factory :estimate_assembly_min_create, :class => EstimateAssembly do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly_create,  :strategy => :build
    selected false
  end
  factory :estimate_assembly_accessible_create, :class => EstimateAssembly do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly_create,  :strategy => :build
    selected true
  end    
  factory :estimate_assembly_accessible, :class => EstimateAssembly do
    selected true
  end    
end
