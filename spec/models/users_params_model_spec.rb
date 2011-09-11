require 'spec_helper'

describe UsersController do

  def minimum_attributes
    {:email => 'email@example.com', :username => 'TestUser'}
  end
  def safe_attributes
    {:first_name => 'Test', :last_name => 'User', :email => 'email@example.com', :username => 'TestUser'}
  end
  def unsafe_attributes
    {:roles => "admin", :encrypted_password => "HackMe", :password_salt => "Hackneyed"}
  end
  def bad_attributes
    {:atmin => "true", :foo => "true", :bar => "true", }
  end


  context 'should validate Users parameters Create (through model) -' do

    it "should create user with the minimum_attributes (model validates_presence_of attributes)" do
      @num_users = User.count
      user = User.create! minimum_attributes
      User.count.should == (@num_users+1)
    end
    
    it 'should not create user missing any one of the minimum_attributes (model validates_presence_of attributes)' do
      minimum_attributes.each do |key, value|
        test_attributes = minimum_attributes
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        minimum_attributes.size.should == (test_attributes.size+1)
        @num_users = User.count
        user = User.create test_attributes
        User.count.should == (@num_users)
      end
    end
    
    it 'should create user with each of the safe_attributes (model attr_accessible attributes)' do
      safe_attributes.each do |key, value|
        @num_users = User.count
        user = User.create! minimum_attributes.merge({key => value})
        User.count.should == (@num_users+1)
      end
    end

    it 'should create user with unsafe_attributes, but should not have any unsafe_attributes (attributes not in model attr_accessible)' do
      unsafe_attributes.each do |key, value|
        @num_users = User.count
        user = User.create minimum_attributes.merge({key => value})
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        User.count.should == (@num_users+1)
      end
    end

    it "should create user with bad_attributes, but should not have any bad_attributes (attributes not in Users model)" do
      bad_attributes.each do |key, value|
        @num_users = User.count
        user = User.create minimum_attributes.merge({key => value})
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        User.count.should == (@num_users+1)
      end
    end

  end
  
end
