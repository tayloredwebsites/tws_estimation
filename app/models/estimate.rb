class Estimate < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :title, :customer_name, :customer_note, :prevailing_wage, :note, :deactivated, :sales_rep_id, :job_type_id, :state_id
  # todo ? remove these as accessible? -> attr_accessible :sales_rep_id, :job_type_id, :state_id

  belongs_to :sales_rep
  belongs_to :job_type
  belongs_to :state
  has_many :estimate_assemblies
  has_many :assemblies, :through => :estimate_assemblies
  # accepts_nested_attributes_for :estimate_assemblies  # this does automatic deletes, not deactivates. requires association to be attr_accessible. does not impact params passed.
  
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

  def update_attributes(params = {})
    Rails.logger.debug("* Estimate - update_attributes - params=#{params.inspect.to_s}")
    # estimate_params = params[:estimate]
    ActiveRecord::Base.transaction do
      Rails.logger.debug("* Estimate.update_attributes - before call to super - self: #{self.inspect.to_s}")
      Rails.logger.debug("* Estimate.update_attributes - before call to super - params: #{params.inspect.to_s}")
      super(params[:estimate]) 
      Rails.logger.debug("* Estimate.update_attributes - after call to super - self:#{self.inspect.to_s}")
      if errors.empty?
        if !params[:estimate_assemblies].nil?
          Rails.logger.debug("* Estimate - update_attributes - call update_estimate_assemblies")
          update_estimate_assemblies_attributes(params[:estimate_assemblies_was], params[:estimate_assemblies])
        else
          # Rails.logger.debug("* Estimate - update_attributes - error Estimate.update_attributes nil :estimate_assemblies param")
          # raise ActiveRecord::Rollback, "Estimate.update_attributes nil :estimate_assemblies param"
          Rails.logger.warn("* Estimate - update_attributes - warning Estimate.update_attributes missing :estimate_assemblies param")
        end
      else
        Rails.logger.debug("* Estimate - update_attributes - got errors = #{errors.inspect.to_s}")
        raise ActiveRecord::Rollback, errors
      end
    end
  end
  
  def update_estimate_assemblies_attributes(was_before = {}, is_now = {})
    Rails.logger.debug("* Estimate.update_estimate_assemblies was_before:#{was_before.inspect.to_s}, is_now:#{is_now.inspect.to_s}")
    was_before.each do |was_id, was_value|
      Rails.logger.debug("* Estimate.update_estimate_assemblies - was:#{was_id},#{was_value}, is_now[was_id]:#{is_now[was_id]}")
      if was_value == 'false'
        # if is now, change
        if !is_now[was_id].nil?
          Rails.logger.debug("* Estimate.update_estimate_assemblies - change estimate_assembly ( estimate_id:#{self.id},assembly_id:#{was_id} ) to true:#{is_now[was_id]}")
          assembly = EstimateAssembly.where(:estimate_id => self.id, :assembly_id => was_id).first
          if assembly.nil?
            assembly = EstimateAssembly.new(:estimate_id => self.id, :assembly_id => was_id)
          end
          Rails.logger.debug("* Estimate.update_estimate_assemblies - create estimate_assembly = #{assembly.inspect.to_s}")
          assembly.selected = true
          assembly.save!
        end
      else
        # if isn't now, change
        if is_now[was_id].nil?
          Rails.logger.debug("* Estimate.update_estimate_assemblies - change estimate_assembly ( estimate_id:#{self.id},assembly_id:#{was_id} ) to false:#{is_now[was_id]}")
          Rails.logger.debug("* Estimate.update_estimate_assemblies - change to false:#{is_now[was_id]}")
          assembly = EstimateAssembly.where(:estimate_id => self.id, :assembly_id => was_id).first
          assembly.selected = false
          assembly.save!
        end
      end
    end
  end

  # self describe this object instance
  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  # the self description of this object instance
  def desc
    ''+super.nil_to_s+self.title.nil_to_s
  end

  # safely describe a field for this object instance
  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
