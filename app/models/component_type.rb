class ComponentType < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :sort_order, :has_costs, :has_hours, :has_vendor, :has_misc, :no_entry, :deactivated

  validates :description,
      :presence => true
    
end
