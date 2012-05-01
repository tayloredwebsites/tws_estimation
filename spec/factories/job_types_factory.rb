# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :job_type_name do |n|
    "JobName#{n}"
  end
  sequence :job_type_description do |n|
    "JobType#{n}"
  end
  sequence :job_type_sort_order do |n|
    n*100
  end
  factory :job_type, :class => ComponentType do
    name              {FactoryGirl.generate(:job_type_name)}
    description       {FactoryGirl.generate(:job_type_description)}
    sort_order        {FactoryGirl.generate(:job_type_sort_order)}
  end
  factory :job_type_min, :class => ComponentType do
    name              {FactoryGirl.generate(:job_type_name)}
  end    
  factory :job_type_accessible, :class => ComponentType do
    name              {FactoryGirl.generate(:job_type_name)}
    description       {FactoryGirl.generate(:job_type_description)}
    sort_order        {FactoryGirl.generate(:job_type_sort_order)}
    deactivated       true
  end    
end
