class Estimate < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :title, :customer_name, :customer_note, :prevailing_wage, :note, :deactivated, :sales_rep_id, :job_type_id, :state_id
  # todo ? remove these as accessible? -> attr_accessible :sales_rep_id, :job_type_id, :state_id

  belongs_to :sales_rep
  belongs_to :job_type
  belongs_to :state
  
  validates :title,
    :presence => true,
    :uniqueness => true
  validates :customer_name,
    :presence => true
  validates :sales_rep_id,
    :presence => true
  validates :job_type_id,
    :presence => true
  validates :state_id,
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
