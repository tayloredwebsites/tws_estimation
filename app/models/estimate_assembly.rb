class EstimateAssembly < ActiveRecord::Base

  include Models::CommonMethods
  
  attr_accessible :selected, :estimate_id, :assembly_id
  # todo ? remove these as accessible? -> attr_accessible :estimate_id, :assembly_id

  belongs_to :estimate
  belongs_to :assembly

  # validates :estimate_id,
  #   :presence => { :message => "is missing estimate_id"}
  validates_presence_of :estimate,
    :message => "is missing estimate"
  # validates :assembly_id,
  #   :presence => { :message => "is missing assembly_id" }
  validates_presence_of :assembly,
    :message => "is missing assembly"

  # methods
  def description
    self.assembly.description
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
    ''+super.nil_to_s+self.description
  end

end
