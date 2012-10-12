class Default < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :store, :name, :value, :deactivated
  
  has_many :components, :inverse_of=>:default, :dependent => :restrict
  
  validates :store,
      :presence => true
  validates :name,
      :presence => true,
      :uniqueness => {:scope => :store}

  # methods

  
  def destroy(*params)
     begin
       super(*params)
     rescue Exception=>ex
       errors.add(:base, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
       Rails.logger.error("ERROR Default.destroy - #{ex.to_s}")
     end
   end

   def delete(*params)
      begin
        super(*params)
      rescue Exception=>ex
        self.errors.add( I18n.translate('errors.error_msg', :msg => ex.to_s ) )
        Rails.logger.error("ERROR Default.delete - #{ex.to_s}")
      end
    end


  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    ''+super.nil_to_s+self.store.nil_to_s+' '+self.name.nil_to_s+' = '+self.value.nil_to_0.to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
