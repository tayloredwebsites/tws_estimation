class State < ActiveRecord::Base

  include Models::CommonMethods

  attr_accessible :code, :name

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

end
