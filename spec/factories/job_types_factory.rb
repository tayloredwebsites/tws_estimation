# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job_type do
    name "MyString"
    description "MyString"
    sort_order 1
    deactivated false
  end
end
