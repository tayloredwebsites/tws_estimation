class EstimateComponent < ActiveRecord::Base

  include Models::CommonMethods
  
  attr_accessible :component, :assembly, :estimate, :value, :write_in_name, :component_id, :assembly_id, :estimate_id, :deactivated
  # todo ? remove these as accessible? -> attr_accessible :assembly_component, :estimate_assembly, :assembly_component_id, :estimate_assembly_id

  belongs_to :estimate
  belongs_to :assembly
  belongs_to :component

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
