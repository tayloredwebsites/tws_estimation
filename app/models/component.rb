class Component < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :calc_only, :deactivated, :component_type_id, :default_id
  # todo ? remove these as accessible? -> attr_accessible :component_type_id, :default_id

  belongs_to :component_type
  belongs_to :default
    
  validates :description,
    :presence => true,
    :uniqueness => {:scope => :component_type_id}

  validates :calc_only,
    :inclusion => { :in => [true, false] }

  validates :component_type_id,
    :presence => true

  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end
  
  def desc
    ''+super.nil_to_s+self.description.nil_to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
