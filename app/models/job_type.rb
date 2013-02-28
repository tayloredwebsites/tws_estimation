class JobType < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods

  attr_accessible :name, :description, :sort_order, :deactivated
  # todo ? remove these as accessible? -> attr_accessible :user_id

  has_many :estimates, :inverse_of=>:job_type, :dependent => :restrict
  has_many :state_component_type_taxes, :inverse_of=>:job_type, :dependent => :restrict

  validates :name,
    :presence => true,
    :uniqueness => true

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

  def destroy(*params)
     begin
       super(*params)
     rescue Exception=>ex
       errors.add(:base, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
       Rails.logger.error("ERROR JobType.destroy - #{ex.to_s}")
     end
   end

  def delete(*params)
    begin
      super(*params)
    rescue Exception=>ex
      self.errors.add( I18n.translate('errors.error_msg', :msg => ex.to_s ) )
      Rails.logger.error("ERROR JobType.delete - #{ex.to_s}")
    end
  end

end
