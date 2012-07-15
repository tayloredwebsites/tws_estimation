class AssemblyComponent < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :required, :deactivated, :component_id, :assembly_id
  # todo ? remove these as accessible? -> attr_accessible :component_id, :assembly_id

  belongs_to :assembly
  belongs_to :component

  validates :assembly_id,
    :presence => true
  validates :component_id,
    :presence => true

  # scopes
  def self.for_assembly(id)
    joins(:component => :component_type).where('assembly_components.assembly_id = ?', id).order('component_types.sort_order, assembly_components.required DESC, components.description')
  end

  # methods
  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    ''+super.nil_to_s+(description.blank? ? self.component.description : self.description)
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
