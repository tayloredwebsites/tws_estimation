class Estimate < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :title, :customer_name, :customer_note, :prevailing_wage, :note, :deactivated, :sales_rep_id, :job_type_id, :state_id, :estimate_assemblies, :estimate_component_attributes

  # attr_accessor :estimate_components_new

  belongs_to :sales_rep
  belongs_to :job_type
  belongs_to :state
  has_many :estimate_assemblies, :inverse_of=>:estimate
  has_many :estimate_components, :inverse_of=>:estimate
  # # has_many :assemblies, :through => :estimate_assemblies
  # accepts_nested_attributes_for :estimate_assemblies  # cannot use the automatic deletes (does not deactivate). requires association to be attr_accessible. does not impact params passed.
  # accepts_nested_attributes_for :estimate_components  # cannot use the automatic deletes (does not deactivate). requires association to be attr_accessible. does not impact params passed.
  
  validates :title,
    :presence => { :message => "requires a title"},
    :uniqueness => true
  validates :customer_name,
    :presence => { :message => "requires a custoner name"}
  validates :sales_rep_id,
    :presence => { :message => "requires a sales rep ID"}
  validates :job_type_id,
    :presence => { :message => "requires a job type ID"}
  validates :state_id,
    :presence => { :message => "requires a state type ID"}

  # self describe this object instance
  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  # the self description of this object instance
  def desc
    ''+super.nil_to_s+self.title.nil_to_s
  end

  # safely describe a field for this object instance
  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
