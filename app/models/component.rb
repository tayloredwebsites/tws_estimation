class Component < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :editable, :deactivated, :component_type_id, :default_id
  # todo ? remove these as accessible? -> attr_accessible :component_type_id, :default_id

  belongs_to :component_type
  belongs_to :default
  has_many :assembly_components, :inverse_of => :component, :dependent => :restrict
  validates_associated :assembly_components
  has_many :estimate_components, :inverse_of => :component, :dependent => :restrict
    
  validates :description,
    :presence => true,
    :uniqueness => {:scope => :component_type_id}

  validates :editable,
    :inclusion => { :in => [true, false] }

  validates :component_type_id,
    :presence => true

  # methods

  def destroy(*params)
     begin
       super(*params)
     rescue Exception=>ex
       errors.add(:base, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
       Rails.logger.error("ERROR Component.destroy - #{ex.to_s}")
     end
   end

   def delete(*params)
      begin
        super(*params)
      rescue Exception=>ex
        self.errors.add( I18n.translate('errors.error_msg', :msg => ex.to_s ) )
        Rails.logger.error("ERROR Component.delete - #{ex.to_s}")
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
  
	# get the operand of the operation (first character)
  def op_operand
		#	- first character of operation = operand ('+' - add. '-' - subtract from scope, '*' - multiply, '/' - divide scope by value)
		# - default operand = *
		op_operand = ( !operation.nil? && operation.length > 1 && %w( + - / * ).include?(operation[0]) ) ? operation[0] : '*'
  end

	# get the scope of the operation (second character)
  def op_scope
		#	- ('A' - use Assembly break, 'I' - Grid initial totals, 'S' - use latest subtotal, 'C' - use cumulative value, 'H' - use cumulative hours)
		# - default scope - C
		op_scope = ( !operation.nil? && operation.length > 1 && %w( A I S C H ).include?(operation[1]) ) ? operation[1] : 'C'
  end
  
end
