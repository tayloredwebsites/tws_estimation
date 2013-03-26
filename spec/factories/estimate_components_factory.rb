# Read about factories at https://github.com/thoughtbot/factory_girl

# return all attributes for create, for later comparison in tests
def generate_estimate_component_accessible_attributes(attribs = {})
  estimate_id = attribs[:estimate_id].nil? ? (Estimate.create!(generate_estimate_min_attributes())).id : attribs[:estimate_id]
  assembly_id = attribs[:assembly_id].nil? ? (Assembly.create!(FactoryGirl.attributes_for(:assembly_create))).id : attribs[:assembly_id]
  component_type_id = attribs[:component_type_id].nil? ? (FactoryGirl.create(:component_type)).id : attribs[:component_type_id]
  component_id = attribs[:component_id].nil? ? (FactoryGirl.create(:component_min_create, :component_type_id => component_type_id)).id : attribs[:component_id]
  deactivated = attribs[:deactivated].nil? ? false : attribs[:deactivated]
  return {
    :estimate_id => estimate_id,
    # :estimate => estimate,
    :assembly_id => assembly_id,
    # :assembly => assembly,
    :component_id => component_id,
    # :component => component,
    :write_in_name => FactoryGirl.generate(:estimate_component_write_in_name),
    :value => FactoryGirl.generate(:estimate_component_value),
    :note => 'a component note',
    :deactivated => deactivated
  }
end

# return minimum attributes required to create, for later comparison in tests
def generate_estimate_component_min_attributes(attribs = {})
  # estimate_id = attribs[:estimate_id].nil? ? Estimate.create!(generate_estimate_min_attributes()) : attribs[:estimate_id]
  # assembly_id = attribs[:assembly_id].nil? ? Assembly.create!(FactoryGirl.attributes_for(:assembly_create)) : attribs[:assembly_id]
  # component_type_id = attribs[:component_type_id].nil? ? FactoryGirl.create(:component_type_accessible) : attribs[:component_type_id]
  # component_id = attribs[:component_id].nil? ? FactoryGirl.create(:component_min_create, :component_type => component_type) : attribs[:component_id]
  estimate_id = attribs[:estimate_id].nil? ? (Estimate.create!(generate_estimate_min_attributes())).id : attribs[:estimate_id]
  assembly_id = attribs[:assembly_id].nil? ? (Assembly.create!(FactoryGirl.attributes_for(:assembly_create))).id : attribs[:assembly_id]
  component_type_id = attribs[:component_type_id].nil? ? (FactoryGirl.create(:component_type)).id : attribs[:component_type_id]
  component_id = attribs[:component_id].nil? ? (FactoryGirl.create(:component_min_create, :component_type_id => component_type_id)).id : attribs[:component_id]
  return {
    :estimate_id => estimate_id,
    # :estimate => estimate,
    :assembly_id => assembly_id,
    # :assembly => assembly,
    :component_id => component_id
    # :component => component
  }
end

FactoryGirl.define do
  sequence :estimate_component_write_in_name do |n|
    n.odd? ? '' : "write_in_#{n/2}" # blank every other item
  end
  sequence :estimate_component_value do |n|
    rand(0.01..9.99).round(2)
  end
  # standard fields used to create an item
  factory :estimate_component, :class => EstimateComponent do
    association :estimate, :factory => :estimate, :strategy => :build
    association :assembly,  :factory => :assembly_create,  :strategy => :build
    association :component,  :factory => :component_create,  :strategy => :build
    write_in_name {FactoryGirl.generate(:estimate_component_write_in_name)}
    value {FactoryGirl.generate(:estimate_component_value)}
    note ''
    deactivated false
  end
  # factory :estimate_component_min_create, :class => EstimateComponent do
  #   association :estimate, :factory => :estimate, :strategy => :build
  #   association :component,  :factory => :component_create,  :strategy => :build
  #   selected false
  # end
  # factory :estimate_component_accessible_create, :class => EstimateComponent do
  #   association :estimate, :factory => :estimate, :strategy => :build
  #   association :component,  :factory => :component_create,  :strategy => :build
  #   selected true
  # end    
  # factory :estimate_component_accessible, :class => EstimateComponent do
  #   selected true
  # end    
end
