require 'spec_helper'

describe UsersController do

  def valid_attributes
    {:first_name => 'Test', :last_name => 'User', :email => 'email@example.com', :username => 'TestUser'}
  end
  def invalid_attributes
    {:first_name => 'Test', :last_name => 'User', :email => 'email@example.com', :username => 'TestUser', :roles => "admin"}
  end

  context 'should ensure that only safe params are updated' do

    it "should not update the requested user with invalid parameters" do
      user = User.create! valid_attributes
      User.any_instance.should_not_receive(:update_attributes).with({'unsafe_field' => 'params'})
      put :update, :id => user.id, :user => {'unsafe_field' => 'params'}
    end

    it "should update the requested user with valid parameters" do
      user = User.create! valid_attributes
      User.any_instance.should_receive(:update_attributes).with({'username' => 'my_user_name'})
      put :update, :id => user.id, :user => {'username' => 'my_user_name'}
      #  assigns(:user).username.should eq('my_user_name')  # doesn't happen see test below (should_receive might interfere with update?)
    end

    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      put :update, :id => user.id, :user => {'username' => 'Testy'}
      assigns(:user).username.should eq('Testy')
    end

    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      put :update, :id => user.id, :user => @valid_attributes
      assigns(:user).should eq(user)
    end


  end

  context 'should ensure that only safe params are post/created' do
  
    it 'should create resource with safe attributes' do
      @num_users = User.count
      #User.any_instance.should_receive(:create).with('username' => valid_attributes[:username])
      post :create, :user => valid_attributes
      response.should be_redirect
      #response.should redirect_to( user_path )
      response.should redirect_to( '/users/1?notice=User+was+successfully+created.' )
      assigns(:user).should_not be_nil
      User.count.should == (@num_users+1)
      assigns(:user).username.should eq(valid_attributes[:username])
    end
    
    it 'should create resource without unsafe attributes' do
      @num_users = User.count
      post :create, :user => invalid_attributes
      response.should be_redirect
      assigns(:user).should_not be_nil
      User.count.should == (@num_users+1)
      assigns(:user).username.should eq(invalid_attributes[:username])
      assigns(:user).roles.should_not eq(invalid_attributes[:roles])
    end
    
  end

end
