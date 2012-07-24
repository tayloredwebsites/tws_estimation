class EstimateComponent < ActiveRecord::Base

  include Models::CommonMethods
  
  attr_accessible :value, :write_in_name, :component_id, :assembly_id, :estimate_id, :deactivated #, :component, :assembly, :estimate
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
  def params_from_keys(new_from_params = {})
    key_string = new_from_params[:key_string].nil? ? "0_0_0_0" : new_from_params[:key_string]
    est_comp_ids = key_string.split("_") # [#{@estimate.id}_#{ass.id}_#{component.id}_#{est_comp.id.to_s}]
    estimate_id = new_from_params[:estimate_id].blank? ? (est_comp_ids[0].blank? ? "0" : est_comp_ids[0]) : new_from_params[:estimate_id]
    assembly_id = new_from_params[:assembly_id].blank? ? (est_comp_ids[1].blank? ? "0" : est_comp_ids[1]) : new_from_params[:assembly_id]
    component_id = new_from_params[:component_id].blank? ? (est_comp_ids[2].blank? ? "0" : est_comp_ids[2]) : new_from_params[:component_id]
    new_from_params.delete(:key_string).merge(:estimate_id => estimate_id, :assembly_id => assembly_id, :component_id => component_id)
    self.new(new_from_params)
  end
  
  # method to create new estimate component from these parameters, default value is from :key_string (passed in post)
  # first pulls IDs from :key_string, then if any ids are passed, then they override the key string values
  def self.params_from_key_string(key_string = "0_0_0_0")
    ids = key_string.split("_") # [#{@estimate.id}_#{ass.id}_#{component.id}_#{est_comp.id.to_s}]
    ret = Hash.new
    ret[:estimate_id] = ids[0] if !ids[0].blank?
    ret[:assembly_id] = (ids[1].blank? ? "0" : ids[1])
    ret[:component_id] = (ids[2].blank? ? "0" : ids[2])
    return ret
  end

  # def build(params = {})
  #   Rails.logger.debug("*bbbbbbb EstimateComponent - build - params=#{params.inspect.to_s}")
  #   Rails.logger.debug("*bbbbbbb EstimateComponent - build - self=#{self.inspect.to_s}")
  # end
  # 
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

end
