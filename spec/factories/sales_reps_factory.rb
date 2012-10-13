# Read about factories at https://github.com/thoughtbot/factory_girl

def generate_sales_rep_accessible_attributes(user_id = nil)
  if user_id == nil
    user = FactoryGirl.create(:user_full_create_attr)
    my_user_id = user.id
  else
    my_user_id = user_id
  end
  return {
    :user_id => my_user_id,
    :min_markup_pct => 0.0,
    :max_markup_pct => 10.0,
    :deactivated => false
  }
end

def generate_sales_rep_min_attributes(user_id = nil)
  if user_id == nil
    user = FactoryGirl.create(:user_full_create_attr)
    my_user_id = user.id
  else
    my_user_id = user_id
  end
  return {
    :user_id => user.id,
    :min_markup_pct => 0.0,
    :max_markup_pct => 10.0
  }
end

FactoryGirl.define do
  factory :sales_rep_create, :class => SalesRep do
    association             :user, :factory => :user, :strategy => :build
    min_markup_pct          0.0
    max_markup_pct          10.0
  end
  factory :sales_rep_min_create, :class => SalesRep do
    association             :user, :factory => :user, :strategy => :build
    min_markup_pct          0.0
    max_markup_pct          10.0
  end
  factory :sales_rep_accessible, :class => SalesRep do
    min_markup_pct          1.0
    max_markup_pct          9.0
    deactivated             true
  end
  factory :sales_rep_accessible_create, :class => SalesRep do
    association             :user, :factory => :user, :strategy => :build
    min_markup_pct          1.0
    max_markup_pct          9.0
    deactivated             true
  end
end
