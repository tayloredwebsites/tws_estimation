class EstimateComponent < ActiveRecord::Base

  include Models::CommonMethods
  
  attr_accessible :value, :write_in_name, :component_id, :assembly_id, :estimate_id, :deactivated, :note #, :component, :assembly, :estimate
  # todo ? remove these as accessible? -> attr_accessible :assembly_component, :estimate_assembly, :assembly_component_id, :estimate_assembly_id

  belongs_to :estimate
  belongs_to :assembly
  belongs_to :component

  # invalidated the build method till Rails 3.1 Identity Maps
  validates :estimate_id,
    :presence => true
  validates :assembly_id,
    :presence => true
  validates :component_id,
    :presence => true
  validates_uniqueness_of :component_id,
    :scope => [:estimate_id, :assembly_id] 

  # after_validation :check_required_has_value

  # scopes
  # def self.for_estimate(id)
  #   joins(:estimate_assembly) & EstimateAssembly.for_estimate(id)
  # end
  def self.for_estimate_assembly_component(estimate_id, assembly_id, component_id)
    where('estimate_id = ? and assembly_id = ? and component_id = ?', estimate_id, assembly_id , component_id ).first
  end
  # def self.assembly_component(assembly_component_id, estimate_id)
  #   joins(:assembly_component => :component).where('estimate_components.assembly_component_id = ? and estimate_components.estimate_id = ?', assembly_component_id, estimate_id ).first
  # end

  # methods
  def description
    (write_in_name.blank? ? self.component.description : self.write_in_name)
  end

  # def estimate_id
  #   self.estimate_assembly.estimate_id
  # end
  # 

  # method to create new estimate component from these parameters, default value is from :key_string (passed in post)
  # first pulls IDs from :key_string, then if any ids are passed, then they override the key string values
  def self.params_from_key_string(key_string = "0_0")
    ids = key_string.split("_") # [#{ass.id}_#{component.id}]
    ret = Hash.new
    # ret[:estimate_id] = ids[0] if !ids[0].blank?
    ret[:assembly_id] = (ids[0].blank? ? "0" : ids[0])
    ret[:component_id] = (ids[1].blank? ? "0" : ids[1])
    return ret
  end

  # method to destroy record is not allowed
  def destroy
    return false
  end

  # method to delete record is not allowed
  def delete
    return false
  end

  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    # ''+super.nil_to_s+self.write_in_name.nil_to_s
    ''+super.nil_to_s+description
  end

  def value_or_default
   (self.component.nil? || self.component.default.nil?) ? self.value_or_zero : BigDecimal.new(self.component.default.value.bd_to_s(2),2)
  end

  def value_or_zero
    if !value.nil?
      BigDecimal.new(self.value.bd_to_s(2),2)
    else
      BIG_DECIMAL_ZERO
    end
  end

  def tax_percent_for(saved_estimate=nil, this_component=nil)
    # load default tax percent value if tax rate is not set yet, by looking in the StateComponentTypeTax table
    if !self[:tax_percent].nil?
      return self[:tax_percent]
    elsif !saved_estimate.nil? && !saved_estimate.state.nil? && !saved_estimate.job_type.nil?  && !this_component.nil? && !this_component.component_type.nil?
      tax_rate_model = StateComponentTypeTax.default_tax_rate_for(saved_estimate.job_type_id, this_component.component_type_id, saved_estimate.state_id)
      if tax_rate_model.nil?
        # Rails.logger.debug("*TaxRate* tax_percent_for - return value of #{self[:tax_percent].bd_to_s(3)}")
        return self[:tax_percent]
      else
        # update the tax rate in model
        tax_percent = tax_rate_model.tax_percent
        # Rails.logger.debug("*TaxRate* tax_percent_for - lookup rate found =  #{tax_rate_model.tax_percent.bd_to_s(3)}")
        return tax_rate_model.tax_percent
      end
    else
      # Rails.logger.debug("*TaxRate* tax_percent_for - nil estimate or component in")
      return self[:tax_percent]
    end
  end
  
  # # is deactivated if component or component type is deactivated
  # def deactivated?
  #   
  # end
  # 
end
