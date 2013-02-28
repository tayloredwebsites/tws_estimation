class StateComponentTypeTax < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods

  attr_accessible :job_type_id, :component_type_id, :state_id, :tax_percent, :deactivated

  belongs_to :job_type
  belongs_to :component_type
  belongs_to :state

  validates :job_type_id,
    :presence => { :message => "requires a Job Type ID"}
  validates :component_type_id,
    :presence => { :message => "requires a Component Type ID"}
  validates :state_id,
    :presence => { :message => "requires a State ID"}
  validates :tax_percent,
    :presence => { :message => "requires a Tax Percent"},
    :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}

  def self.default_tax_rate_for(job_type_id, component_type_id, state_id)
    where("job_type_id = ? AND component_type_id = ? AND state_id = ?", job_type_id, component_type_id, state_id).first
  end
  
  def nil_to_s
    # call to super here brings in deactivated feature
    code + ' - ' + name
  end

  def desc
    ''+super.nil_to_s + self.tax_percent.nil_to_0.to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    if field_name == tax_percent
      tax_percent_nil_to_s
    else
      ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
    end
  end

  def tax_percent_nil_to_s
    if !tax_percent.nil?
      self.tax_percent.bd_to_s(2)
    else
      '0.00'
    end
  end

end
