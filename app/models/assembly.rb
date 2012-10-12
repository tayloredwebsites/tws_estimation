class Assembly < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :sort_order, :required, :deactivated
    
  has_many :assembly_components, :inverse_of=>:assembly, :dependent => :restrict
  # validates_associated :assembly_components
  has_many :estimate_assemblies, :inverse_of=>:assembly, :dependent => :restrict
  # validates_associated :estimate_assemblies
  has_many :estimate_components, :inverse_of=>:assembly, :dependent => :restrict
  has_many :estimates, :through => :estimate_assemblies, :dependent => :restrict
  validates_associated :estimates

  validates :description,
    :presence => { :message => "requires a description"},
    :uniqueness => true

  validates :sort_order,
    :numericality => {:only_integer => true }
    
  validates :required,
    :inclusion => { :in => [true, false] }
  
  # methods
  
  def destroy(*params)
     begin
       super(*params)
     rescue Exception=>ex
       errors.add(:base, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
       Rails.logger.error("ERROR Assembly.destroy - #{ex.to_s}")
     end
   end

   def delete(*params)
      begin
        super(*params)
      rescue Exception=>ex
        self.errors.add( I18n.translate('errors.error_msg', :msg => ex.to_s ) )
        Rails.logger.error("ERROR Assembly.delete - #{ex.to_s}")
      end
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
