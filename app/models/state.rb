class State < ActiveRecord::Base

  include Models::CommonMethods

  attr_accessible :code, :name

  has_many :estimates, :inverse_of=>:state, :dependent => :restrict
  has_many :state_component_type_taxes, :inverse_of=>:state, :dependent => :restrict

  validates :code,
    :presence => true,
    :uniqueness => true

    validates :name,
      :presence => true,
      :uniqueness => true

  def nil_to_s
    # call to super here brings in deactivated feature
    code + ' - ' + name
  end

  def desc
    ''+super.nil_to_s + self.code.nil_to_s + ' - ' + self.code.nil_to_s
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
       Rails.logger.error("ERROR State.destroy - #{ex.to_s}")
     end
   end

  def delete(*params)
    begin
      super(*params)
    rescue Exception=>ex
      self.errors.add( I18n.translate('errors.error_msg', :msg => ex.to_s ) )
      Rails.logger.error("ERROR State.delete - #{ex.to_s}")
    end
  end

end
