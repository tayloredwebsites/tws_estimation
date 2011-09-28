require 'spec_helper'
include UserTestHelper

describe UsersController do


  context "should validate Users parameters Create (through model)\n -" do

    it "should raise an error create user with no attributes" do
      @num_users = User.count
      lambda {User.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      User.count.should == (@num_users)
    end
    
    it "should not create user, with errors when created with no attributes" do
      @num_users = User.count
      user = User.create()
      user.should be_instance_of(User)
      user.username.should be_nil
      user.id.should be_nil
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end
    
    it "should create user, with errors when created with the minimum_attributes (model validates_presence_of attributes)" do
      @num_users = User.count
      user = User.create(UserTestHelper.user_minimum_create_attributes)
      user.should be_instance_of(User)
      user.username.should == UserTestHelper.user_minimum_create_attributes[:username]
      user.id.should_not be_nil
      user.errors.count.should == 0
      User.count.should == (@num_users+1)
    end
    
    it "should not create user, with errors when created with the minimum_attributes without password" do
      @num_users = User.count
      user = User.create({:email => 'email@example.com', :username => 'TestUser', :password_confirmation => 'test'})
      user.should be_instance_of(User)
      user.username.should == UserTestHelper.user_minimum_create_attributes[:username]
      user.password.should be_nil
      user.id.should be_nil
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end
    
    it "should not create user, with errors when created with the minimum_attributes without password_confirmation" do
      @num_users = User.count
      user = User.create({:email => 'email@example.com', :username => 'TestUser', :password => 'test'})
      user.should be_instance_of(User)
      user.username.should == UserTestHelper.user_minimum_create_attributes[:username]
      user.password_confirmation.should be_nil
      user.id.should be_nil
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end
    
    it 'should not create user, with errors when created with any one of the minimum_attributes missing (model validates_presence_of attributes)' do
      UserTestHelper.user_minimum_create_attributes.each do |key, value|
        test_attributes = UserTestHelper.user_minimum_create_attributes
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        (UserTestHelper.user_minimum_create_attributes).size.should == (test_attributes.size+1)
        @num_users = User.count
        user = User.create test_attributes
        user.should be_instance_of(User)
        user[key].should be_nil
        user.id.should be_nil
        user.errors.count.should > 0
        User.count.should == (@num_users)
      end
    end
    
    it 'should create user with each of the safe_attributes (model attr_accessible attributes)' do
      UserTestHelper.user_safe_attributes.each do |key, value|
        @num_users = User.count
        user = User.create!(UserTestHelper.user_minimum_create_attributes.merge({key => value}))
        User.count.should == (@num_users+1)
      end
    end

    it 'should create user, with no errors when created with unsafe_attributes, but should not have any unsafe_attributes (attributes not in model attr_accessible)' do
      UserTestHelper.user_unsafe_attributes.each do |key, value|
        @num_users = User.count
        user = User.create(UserTestHelper.user_minimum_create_attributes.merge({key => value}))
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        user.errors.count.should == 0
        User.count.should == (@num_users+1)
      end
    end

    it "should not create user, with errors when created with bad_attributes, but should not have any bad_attributes (attributes not in Users model)" do
      UserTestHelper.user_bad_attributes.each do |key, value|
        @num_users = User.count
        user = User.create(UserTestHelper.user_minimum_create_attributes.merge({key => value}))
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        user.errors.count.should == 0
        User.count.should == (@num_users+1)
      end
    end

  end
  
end
