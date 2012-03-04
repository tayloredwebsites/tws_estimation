class Default < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :store, :name, :value, :deactivated

  validates :store,
      :presence => true
  validates :name,
      :presence => true,
      :uniqueness => true
    
end
