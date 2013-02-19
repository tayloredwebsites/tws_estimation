# Read about factories at https://github.com/thoughtbot/factory_girl

# it 'should have a StateComponentTypeTax table to store the default tax rate by State and Component Type'

FactoryGirl.define do
  sequence :tax_percent do |n|
    BigDecimal.new("#{n.modulo(9) * 0.875}",4)
  end 
  factory :state_component_type_tax, :class => 'StateComponentTypeTax' do
    association             :state, :factory => :state, :strategy => :build
    association             :job_type, :factory => :job_type, :strategy => :build
    association             :component_type, :factory => :component_type, :strategy => :build
    tax_percent             {FactoryGirl.generate(:tax_percent)}
    deactivated             false
  end
  factory :state_component_type_non_taxable, :class => 'StateComponentTypeTax' do
    association             :state, :factory => :state, :strategy => :build
    association             :job_type, :factory => :job_type, :strategy => :build
    association             :component_type, :factory => :component_type, :strategy => :build
    tax_percent             6.0000
    deactivated             false
  end
  factory :state_component_type_tax_changes, :class => 'StateComponentTypeTax' do
    association             :state, :factory => :state, :strategy => :build
    association             :job_type, :factory => :job_type, :strategy => :build
    association             :component_type, :factory => :component_type, :strategy => :build
    tax_percent             7.0000
    deactivated             true
  end
end
