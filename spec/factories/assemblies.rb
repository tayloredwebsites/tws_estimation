# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :assembly_description do |n|
    "Description#{n}"
  end
  sequence :assembly_sort_order do |n|
    n*100
  end
  # standard fields used to create an item
  factory :assembly_create, :class => Assembly do
    description             {FactoryGirl.generate(:assembly_description)}
    sort_order              {FactoryGirl.generate(:assembly_sort_order)}
    required                true
  end
  # minimum fields defined to create an item
  factory :assembly_min_create, :class => Assembly do
    description             {FactoryGirl.generate(:assembly_description)}
    # sort_order              {FactoryGirl.generate(:assembly_sort_order)}
    # required                true
  end    
  # all fields defined and available as attributes
  factory :assembly_accessible, :class => Assembly do
    description             'Changed Description'
    sort_order              5450
    required                false
    deactivated             true
  end
  # factory to create an item that matches :assembly_accessible (happens to be the same here)
  # useful to create a deactivated item
  factory :assembly_accessible_create, :class => Assembly do
    description             'Changed Description'
    sort_order              5450
    required                false
    deactivated             true
  end
end
