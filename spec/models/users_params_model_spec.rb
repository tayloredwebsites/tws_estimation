require 'spec_helper'
include UserTestHelper

describe UsersController do


  context 'should validate Users parameters Create (through model) -' do

    it "should create user with the minimum_attributes (model validates_presence_of attributes)" do
      @num_users = User.count
      user = User.create! UserTestHelper.user_minimum_attributes
      User.count.should == (@num_users+1)
    end
    
    it 'should not create user missing any one of the minimum_attributes (model validates_presence_of attributes)' do
      user_minimum_attributes.each do |key, value|
        test_attributes = UserTestHelper.user_minimum_attributes
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        UserTestHelper.user_minimum_attributes.size.should == (test_attributes.size+1)
        @num_users = User.count
        user = User.create test_attributes
        User.count.should == (@num_users)
      end
    end
    
    it 'should create user with each of the safe_attributes (model attr_accessible attributes)' do
      UserTestHelper.user_safe_attributes.each do |key, value|
        @num_users = User.count
        user = User.create! UserTestHelper.user_minimum_attributes.merge({key => value})
        User.count.should == (@num_users+1)
      end
    end

    it 'should create user with unsafe_attributes, but should not have any unsafe_attributes (attributes not in model attr_accessible)' do
      UserTestHelper.user_unsafe_attributes.each do |key, value|
        @num_users = User.count
        user = User.create UserTestHelper.user_minimum_attributes.merge({key => value})
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        User.count.should == (@num_users+1)
      end
    end

    it "should create user with bad_attributes, but should not have any bad_attributes (attributes not in Users model)" do
      UserTestHelper.user_bad_attributes.each do |key, value|
        @num_users = User.count
        user = User.create UserTestHelper.user_minimum_attributes.merge({key => value})
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        User.count.should == (@num_users+1)
      end
    end

  end
  
end
