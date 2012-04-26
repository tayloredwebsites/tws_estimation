# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sales_rep do
    user_id 1
    min_markup_pct ""
    max_markup_pct ""
    deactivated false
  end
end
