class ComponentType < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :sort_order, :has_costs, :has_hours, :has_vendor, :has_totals, :in_totals_grid, :deactivated

  has_many :components, :inverse_of=>:component_type, :dependent => :restrict
    
  validates :description,
      :presence => true
  
  # methods
  
  def destroy(*params)
     begin
       super(*params)
     rescue Exception=>ex
       errors.add(:base, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
       Rails.logger.error("ERROR ComponentType.destroy - #{ex.to_s}")
     end
   end

   def delete(*params)
      begin
        super(*params)
      rescue Exception=>ex
        self.errors.add( I18n.translate('errors.error_msg', :msg => ex.to_s ) )
        Rails.logger.error("ERROR ComponentType.delete - #{ex.to_s}")
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
