class SalesRep < ActiveRecord::Base

  include Models::Deactivated
  include Models::CommonMethods

  attr_accessible :min_markup_pct, :max_markup_pct, :deactivated, :user_id
  # todo ? remove these as accessible? -> attr_accessible :user_id

  belongs_to :user
  has_many :estimates

  validates :min_markup_pct,
    :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}

  validates :max_markup_pct,
    :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}

  validates :user_id,
    :presence => true,
    :uniqueness => true

  def username
    self.user.username
  end

  def first_name
    self.user.first_name
  end

  def last_name
    self.user.last_name
  end

  def nil_to_s
    # call to super here brings in deactivated feature
    desc
  end

  def desc
    ''+super.nil_to_s+self.user.last_name.nil_to_s+', '+self.user.first_name.nil_to_s
  end

  def field_nil_to_s(field_name)
    # call to super here brings in deactivated feature
    ret = ''+super(field_name).nil_to_s+self.send(field_name).nil_to_s
  end

end
