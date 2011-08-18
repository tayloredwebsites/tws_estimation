# spec/models/user_spec.rb
require 'spec_helper'

describe User do
  it 'should create a new resource given valid attributes' do
    User.create!(:first_name => 'Test', :last_name => 'User', :email => 'email@example.com', :username => 'TestUser')
  end
  
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

