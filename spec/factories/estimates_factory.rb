# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :estimate do
    name "MyString"
    customer_name "MyString"
    customer_notes "MyString"
    sales_rep nil
    job_type nil
    state nil
    prevailing_wage false
    notes "MyString"
    deactivated false
  end
end
