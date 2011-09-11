class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :username
  validates_presence_of :email, :username
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  roles              :string(255)
#  username           :string(255)
#  encrypted_password :string(255)
#  password_salt      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

