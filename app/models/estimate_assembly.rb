class EstimateAssembly < ActiveRecord::Base

  include Models::CommonMethods
  
  attr_accessible :selected, :estimate_id, :assembly_id
  # todo ? remove these as accessible? -> attr_accessible :estimate_id, :assembly_id

  belongs_to :estimate
  belongs_to :assembly

  validates :estimate_id,
    :presence => true
  validates :assembly_id,
    :presence => true

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
    ''+super.nil_to_s+self.description.nil_to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
