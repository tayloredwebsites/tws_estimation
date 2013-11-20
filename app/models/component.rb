class Component < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods

  attr_accessible :description, :editable, :deactivated, :component_type_id, :default_id, :grid_operand, :grid_scope, :grid_subtotal, :labor_rate_default_id, :types_in_calc
  # todo ? remove these as accessible? -> attr_accessible :component_type_id, :default_id

  belongs_to :component_type
  belongs_to :default
  belongs_to :labor_rate_default, :class_name => 'Default'
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

  validates_presence_of :labor_rate_default_id, :if => :is_hourly_type?, :message => "Hourly components require a rate!"

  validate :validate_misc

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

  # misc. validations
  def validate_misc
    nil_grid_values
    types_in_calc.split(' ').each do |type|
      #look up each component type id here and return false if invalid
      Rails.logger.debug("*** Component.validate_save lookup component_type_id: #{type}")
      begin
        comp_type = ComponentType.find(type)
      rescue Exception=>ex
        errors.add(:types_in_calc, I18n.translate('errors.error_msg', :msg => ex.to_s ) )
        return false
      end
      if comp_type.blank?
        errors.add(:types_in_calc, I18n.translate('errors.cannot_find_obj_id', :obj => 'Component Type', :id => type ) )
        return false
      end
    end
    return true
  end



  def is_hourly_type?
    self.component_type.nil? ? false : self.component_type.has_hours
  end

end
