# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assembly do
    description "MyString"
    sort_order 1
    required false
    deactivated false
  end
end
