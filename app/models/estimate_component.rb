class EstimateComponent < ActiveRecord::Base

  include Models::CommonMethods

  attr_accessible :value, :write_in_name, :component_id, :assembly_id, :estimate_id, :deactivated, :note, :types_in_calc #, :component, :assembly, :estimate
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

  validate :validate_misc

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
    # ''+super.nil_to_s+description
    ''+(self.write_in_name.nil_to_s == '' ? (self.component.nil? ? '' : self.component.description) : self.write_in_name)
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
    Rails.logger.debug("@@@@ tax_percent_for self: #{self.inspect.to_s}")
    if !tax_percent.nil?
      Rails.logger.debug("**** tax_percent_for !tax_percent.nil? - return tax_percent: #{tax_percent}")
      return tax_percent
    elsif !saved_estimate.nil? && !saved_estimate.state.nil? && !saved_estimate.job_type.nil?  && !this_component.nil? && !this_component.component_type.nil?
      Rails.logger.debug("**** tax_percent_for lookup tax percent")
      tax_rate_model = StateComponentTypeTax.default_tax_rate_for(saved_estimate.job_type_id, this_component.component_type_id, saved_estimate.state_id)
      if tax_rate_model.nil?
        return tax_percent
      else
        # update the tax rate in model
        tax_percent = tax_rate_model.tax_percent
        return tax_rate_model.tax_percent
      end
    else
      return tax_percent
    end
  end


  def is_hourly? (this_component=nil)
    my_component = self.component.nil? ? this_component : self.component
    if my_component.nil?
      return false
    elsif my_component.component_type.nil?
      return false
    else
      return my_component.component_type.has_hours
    end
  end

  def has_value?
    (self.value == nil || self.value.bd_to_s(1) == '0.0') ? false : true
  end

  def labor_rate_for(this_estimate=nil, this_component=nil)
    # update the labor fields before returning value
    calculate_labor_fields(this_estimate, this_component)
    if !labor_rate_value.nil?
      return labor_rate_value
    else
      return BIG_DECIMAL_ZERO
    end
  end

  def calculate_labor_fields(this_estimate = nil, this_component=nil)
    if is_hourly?(this_component)
      # update the estimate component's labor fields, since this is an hourly component
      # will update the model labor_rate_value if not set yet, and component rate is found (should be)
      my_component = self.component.nil? ? this_component : self.component
      if labor_rate_value.nil? && !my_component.nil?
        self.labor_rate_value = my_component.labor_rate_default.nil? ? BIG_DECIMAL_ZERO : my_component.labor_rate_default.value
      end
      # will update the model labor_value if there us a labor rate value and a component value
      if !labor_rate_value.nil? && !value.nil?
        self.labor_value = labor_rate_value * value
      end
    end
  end

  def calculate_fields(this_estimate = nil, this_component=nil)
    calculate_labor_fields(this_estimate, this_component)
    self.tax_percent = tax_percent_for(this_estimate, this_component)
    # only compute tax amount here, if not in totals grid, which uses this value to compute with.
    # note totals grid computes the tax amount on the computed value not the value to compute with.
    if !this_component.component_type.has_totals
      self.tax_percent = BIG_DECIMAL_ZERO if self.tax_percent.nil?
      self.tax_amount = self.tax_percent * BIG_DECIMAL_PERCENT * (self.is_hourly?(this_component) ? labor_value : value)
    end
    Rails.logger.debug("****** self(estimate_component) - id: #{self.id}, value: #{self.value.bd_to_s(2)}, tax_percent: #{self.tax_percent.bd_to_s(3)}, tax_amount: #{self.tax_amount.bd_to_s(2)}, labor_rate_value: #{self.labor_rate_value.bd_to_s(3)}, labor_value: #{self.labor_value.bd_to_s(2)}")
    Rails.logger.debug("****** this_component: #{this_component.id} - #{this_component.description}, tax_percent: #{tax_percent.bd_to_s(2)}, value: #{(is_hourly?(this_component) ? labor_value : value).bd_to_s(3)}")
    Rails.logger.debug("****** this_component: #{this_component.id} - #{this_component.inspect.to_s}")
    Rails.logger.debug("****** this_component.component_type: #{this_component.component_type.id} - #{this_component.component_type.inspect.to_s}")
  end

  def initialize_from_assembly_component(ass_comp)
    self.assembly_id = ass_comp.assembly_id
    self.component_id = ass_comp.component_id
  end

  # misc. validations
  def validate_misc
    types_in_calc.split(' ').each do |type|
      #look up each component type id here and return false if invalid
      Rails.logger.debug("*** EstimateComponent.validate_save lookup component_type_id: #{type}")
      begin
        comp_type = ComponentType.find(type)
      rescue Exception=>ex
        errors.add(:types_in_calc, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
        return false
      end
      if comp_type.blank?
        errors.add(:types_in_calc, I18n.translate('errors.cannot_find_obj_id', :obj => 'Component Type', :id => type ) )
        return false
      end
    end
    return true
  end

end
