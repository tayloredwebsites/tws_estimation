# Read about factories at https://github.com/thoughtbot/factory_girl

# return all attributes for create, for later comparison in tests
def generate_estimate_accessible_attributes(estimate_attribs = {})
  sales_rep_id = estimate_attribs[:sales_rep_id].nil? ? SalesRep.create!(generate_sales_rep_accessible_attributes()).id : estimate_attribs[:sales_rep_id]
  job_type_id = estimate_attribs[:job_type_id].nil? ? JobType.create!(FactoryGirl.attributes_for(:job_type)).id : estimate_attribs[:job_type_id]
  state_id = estimate_attribs[:state_id].nil? ? State.create!(FactoryGirl.attributes_for(:state)).id : estimate_attribs[:state_id]
  return {
    :title              => FactoryGirl.generate(:estimate_title),
    :customer_name      => FactoryGirl.generate(:estimate_customer_name),
    :customer_note      => FactoryGirl.generate(:estimate_customer_note),
    :sales_rep_id       => sales_rep_id,
    :job_type_id        => job_type_id,
    :state_id           => state_id,
    :prevailing_wage    => false,
    :note               => FactoryGirl.generate(:estimate_note),
    :deactivated        => false
  }
end

# return minimum attributes required to create, for later comparison in tests
def generate_estimate_min_attributes(estimate_attribs = {})
  sales_rep_id = estimate_attribs[:sales_rep_id].nil? ? SalesRep.new(generate_sales_rep_accessible_attributes()).id : estimate_attribs[:sales_rep_id]
  job_type_id = estimate_attribs[:job_type_id].nil? ? JobType.new(FactoryGirl.attributes_for(:job_type)).id : estimate_attribs[:job_type_id]
  state_id = estimate_attribs[:state_id].nil? ? State.new(FactoryGirl.attributes_for(:state)).id : estimate_attribs[:state_id]
  return {
    :title              => FactoryGirl.generate(:estimate_title),
    :customer_name      => FactoryGirl.generate(:estimate_customer_name),
    :sales_rep_id       => sales_rep_id,
    :job_type_id        => job_type_id,
    :state_id           => state_id
  }
end

FactoryGirl.define do
  
  sequence :estimate_title do |n|
    "EstimateTitle#{n}"
  end
  sequence :estimate_customer_name do |n|
    "EstimateCustomerName#{n}"
  end
  sequence :estimate_customer_note do |n|
    "EstimateCustomerNote#{n}"
  end
  sequence :estimate_note do |n|
    "EstimateNote#{n}"
  end
  factory :estimate, :class => Estimate do
    title             {FactoryGirl.generate(:estimate_title)}
    customer_name     {FactoryGirl.generate(:estimate_customer_name)}
    customer_note     {FactoryGirl.generate(:estimate_customer_note)}
    association       :sales_rep,  :factory => :sales_rep_create,  :strategy => :build
    association       :job_type,  :factory => :job_type,  :strategy => :build
    association       :state,  :factory => :state,  :strategy => :build
    prevailing_wage   false
    note              {FactoryGirl.generate(:estimate_note)}
    deactivated       false
  end
  factory :estimate_min, :class => Estimate do
    title             {FactoryGirl.generate(:estimate_title)}
    customer_name     {FactoryGirl.generate(:estimate_customer_name)}
    association       :sales_rep,  :factory => :sales_rep_create,  :strategy => :build
    association       :job_type_id,  :factory => :job_type,  :strategy => :build
    association       :state_id,  :factory => :state,  :strategy => :build
  end    
  factory :estimate_accessible_create, :class => Estimate do
    title             'My Title'
    customer_name     'Customer Name'
    customer_note     'A note about the customer'
    association       :sales_rep,  :factory => :sales_rep_create,  :strategy => :build
    association       :job_type,  :factory => :job_type,  :strategy => :build
    association       :state,  :factory => :state,  :strategy => :build
    prevailing_wage   true
    note              'A note about the estimate'
    deactivated       true
  end    
  factory :estimate_accessible, :class => Estimate do
    title             'My Title'
    customer_name     'Customer Name'
    customer_note     'A note about the customer'
    prevailing_wage   true
    note              'A note about the estimate'
    deactivated       true
  end    
end
