# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assembly_component do
    component_id ""
    assembly_id ""
    description "MyString"
    required false
    deactivated false
  end
end
