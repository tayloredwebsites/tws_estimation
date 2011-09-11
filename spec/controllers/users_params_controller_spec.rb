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


  context 'UsersController should validate Users parameters on a Post Create -' do

    it "should create with the minimum_attributes (controller required_params_init attributes)" do
      @num_users = User.count
      post :create, :user => minimum_attributes
      assigns(:user).should_not be_nil
      assigns(:user).should be_instance_of(User) 
      User.count.should == (@num_users+1)
    end

    it 'should not create user missing any one of the minimum_attributes (controller required_params_init attributes)' do
      minimum_attributes.each do |key, value|
        test_attributes = minimum_attributes
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        minimum_attributes.size.should == (test_attributes.size+1)
        @num_users = User.count
        post :create, :user => test_attributes
        assigns(:user).should be_nil
        User.count.should == (@num_users)
      end
    end

    it 'should create user with each of the safe_attributes (safe_params_init attributes)' do
      minimum_attributes.each do |key, value|
        @num_users = User.count
        post :create, :user => minimum_attributes.merge({key => value})
        assigns(:user).should_not be_nil
        assigns(:user).should be_instance_of(User)
        assigns(:user)[key].should == value
        User.count.should == (@num_users+1)
      end
    end
    
    it "should not create user with any of the unsafe_attributes  (attributes not in safe_params_init call)" do
      unsafe_attributes.each do |key, value|
        @num_users = User.count
        post :create, :user => minimum_attributes.merge({key => value})
        assigns(:user).should be_nil
        User.count.should == (@num_users)
      end
    end

    it "should not create user with any of the bad_attributes (attributes not in Users model)" do
      bad_attributes.each do |key, value|
        @num_users = User.count
        post :create, :user => minimum_attributes.merge({key => value})
        assigns(:user).should be_nil
        User.count.should == (@num_users)
      end
    end

  end
  
end
