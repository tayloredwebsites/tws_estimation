class Component < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods
  
  attr_accessible :description, :editable, :deactivated, :component_type_id, :default_id, :grid_operand, :grid_scope, :grid_subtotal
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
  
  validates :grid_operand,
    :allow_nil => true,
    :allow_blank => true,
    :inclusion => { :in => VALID_GRID_OPERANDS, :message => "operand must be '+' - add. '-' - subtract, '*' - multiply, '/' - divide, '%' - percent"}

  validates :grid_scope,
    :allow_nil => true,
    :allow_blank => true,
    :inclusion => { :in => VALID_GRID_SCOPES, :message => "scope must be 'A' - Assembly break, 'I' - Grid initial, 'S' - latest subtotal, 'C' - cumulative, 'H' - hours (cumulative)"}
    
  before_save :nil_grid_values

  # class methods

  def self.list_by_desc_with_type
    joins(:component_type).order('components.description, component_types.description')
  end
  
  
  # instance methods
  
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
  
  def desc_plus_type
    desc + ' (' + self.component_type.description + ')'
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end
  
  def is_valid_grid_operand?
    VALID_GRID_OPERANDS.has_key?(grid_operand) ? true : false
  end
  def get_grid_operand_or_warn
    is_valid_grid_operand? ? grid_operand : '?'
  end
  def grid_operand_key_value
     grid_operand + ' - ' + VALID_GRID_OPERANDS[grid_operand] if is_valid_grid_operand?
  end
  
  def is_valid_grid_scope?
    VALID_GRID_SCOPES.has_key?(grid_scope) ? true : false
  end
  def get_grid_scope_or_warn
    is_valid_grid_scope? ? grid_scope : '?'
  end
  def grid_scope_key_value
     grid_scope + ' - ' + VALID_GRID_SCOPES[grid_scope] if is_valid_grid_scope?
  end
  
  def nil_grid_values
    grid_operand = nil if grid_scope == ''
    grid_scope = nil if grid_scope == ''
    grid_subtotal = nil if grid_scope == ''
  end

end
