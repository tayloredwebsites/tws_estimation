class AssemblyComponent < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :required, :deactivated, :component_id, :assembly_id
  # todo ? remove these as accessible? -> attr_accessible :component_id, :assembly_id

  belongs_to :assembly
  belongs_to :component

  # validates :assembly_id,
  #   :presence => true
  validates_presence_of :assembly,
    :message => "is missing assembly"
  # validates :component_id,
  #   :presence => true
  validates_presence_of :component,
    :message => "is missing component"
  validates_uniqueness_of :component_id,
    :scope => [:assembly_id] 

  # scopes
  # list assembly_components for assembly.id = id ( used in app/views/estimate_components/_list.html.erb)
  # sorts by component_type and description
  # note subtotal is added to sort, so that required components sort within the subtotal as well.
  def self.for_assembly(id)
    # joins(:component => :component_type).where('assembly_components.assembly_id = ?', id).order('component_types.sort_order, assembly_components.required DESC, components.description')
    # dont include deactivated assembly components
    joins(:component => :component_type).where("assembly_components.deactivated = ? AND assembly_components.assembly_id = ?", DB_FALSE, id).order('component_types.sort_order, components.grid_subtotal, assembly_components.required DESC, components.description')
  end
  
  # methods
  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    ''+super.nil_to_s+(description.blank? ? self.component.description : self.description)
  end

end
