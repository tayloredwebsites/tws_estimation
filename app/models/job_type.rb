class JobType < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods

  attr_accessible :name, :description, :sort_order, :deactivated
  # todo ? remove these as accessible? -> attr_accessible :user_id

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

end