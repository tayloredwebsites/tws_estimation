class Default < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :store, :name, :value, :deactivated

  validates :store,
      :presence => true
  validates :name,
      :presence => true,
      :uniqueness => {:scope => :store}

  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    ''+super.nil_to_s+self.store.nil_to_s+' '+self.name.nil_to_s+' = '+self.value.nil_to_0.to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
