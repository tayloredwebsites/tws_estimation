class Assembly < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :sort_order, :required, :deactivated
    
  has_many :assembly_components, :inverse_of=>:assembly
  has_many :estimate_assemblies, :inverse_of=>:assembly
  has_many :estimates, :through => :estimate_assemblies

  validates :description,
    :presence => { :message => "requires a description"},
    :uniqueness => true

  validates :sort_order,
    :numericality => {:only_integer => true }
    
  validates :required,
    :inclusion => { :in => [true, false] }

  # # scopes
  # def self.for_assembly(id)
  #   joins(:assembly) & self.find(id)
  # end
  # 
  # methods
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
