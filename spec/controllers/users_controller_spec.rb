require 'spec_helper'
include UserTestHelper
include ApplicationHelper


describe UsersController do

  before(:each) do
    clear_session
  end
  
  context 'not logged in (guest user) -' do
    it 'should not be able to GET the index page and not assign all users as @users' do
      user = FactoryGirl.create(:reg_user_min_create_attr)
      get :index
      # response.should_not be_success
      # response.code.should be == '302'
      # response.should be_redirect
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
    it 'should not be able to GET new user as @user' do
      get :new
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
    it 'should not be able to POST create' do
      expect {
        post :create, :user => FactoryGirl.attributes_for(:reg_user_min_create_attr)
      }.to change(User, :count).by(0)
      post :create, :user => FactoryGirl.attributes_for(:reg_user_min_create_attr)
      response.should redirect_to('/signin')
    end
    it 'should not be able to GET edit' do
      user = FactoryGirl.create(:reg_user_min_create_attr)
      get :edit, :id => user.id.to_s
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
    it 'should not be able to PUT update' do
      user = FactoryGirl.create(:reg_user_min_create_attr)
      put :update, :id => user.id, :user => (FactoryGirl.attributes_for(:reg_user_min_attr)).merge(FactoryGirl.attributes_for(:user_safe_attr))
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
    it 'should not be able to GET show' do
      user = FactoryGirl.create(:reg_user_min_create_attr)
      get :show, :id => user.id
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end

    it 'should not be able to navigate to the DELETE destroy page' do
      user = FactoryGirl.create(:reg_user_min_create_attr)
      delete :destroy, :id => user.id
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
    
    #it 'should be able to navigate to the PUT reset_password page with username and email' do
    #  user = FactoryGirl.create(:reg_user_min_create_attr)
    #  #put :reset_password, :id => user.id, :user =>{:username => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username], :email => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:email]}
    #  put :reset_password, :id => user.id, :user =>{
    #    :username => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username],
    #    :email => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:email]
    #  }
    #  response.should_not redirect_to('/home/errors')
    #  response.should render_template("show")
    #  assigns(:user).should_not be_nil
    #  assigns(:user).should be_a(User)
    #  assigns(:user).username.should == 'RegUser'
    #end
    #it 'should be able to navigate to the PUT reset_password page with just username' do
    #  user = FactoryGirl.create(:reg_user_min_create_attr)
    #  #put :reset_password, :id => user.id, :user =>{:username => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username], :email => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:email]}
    #  put :reset_password, :id => user.id, :user =>{
    #   :username => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username],
    #   :email => ''
    #  }
    #  response.should_not redirect_to('/home/errors')
    #  response.should render_template("show")
    #  assigns(:user).should_not be_nil
    #  assigns(:user).should be_a(User)
    #  assigns(:user).username.should == 'RegUser'
    #end
    #it 'should be able to navigate to the PUT reset_password page with just email' do
    #  user = FactoryGirl.create(:reg_user_min_create_attr)
    #  #put :reset_password, :id => user.id, :user =>{:username => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username], :email => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:email]}
    #  put :reset_password, :id => user.id, :user =>{
    #    :username => '',
    #    :email => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:email]
    #  }
    #  response.should_not redirect_to('/home/errors')
    #  response.should render_template("show")
    #  assigns(:user).should_not be_nil
    #  assigns(:user).should be_a(User)
    #  assigns(:user).username.should == 'RegUser'
    #end
    #it 'should not be able to navigate to the PUT reset_password page unless there is a username or email' do
    #  user = FactoryGirl.create(:reg_user_min_create_attr)
    #  #put :reset_password, :id => user.id, :user =>{:username => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username], :email => FactoryGirl.attributes_for(:reg_user_min_create_attr)[:email]}
    #  put :reset_password, :id => user.id, :user =>{
    #    :username => '',
    #    :email => ''
    #  }
    #  response.should redirect_to('/home/errors') # not to login - want user to see errors, not try to login
    #  response.should_not render_template("show")
    #end
                        
  end
  
  context 'logged in admin user -' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
    end
    
    it 'should be able to GET the index page and see all users (@users)' do
      # user = FactoryGirl.create(:user_min_create_attr)
      user = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:users).should eq([@me,user]) # array of all users
    end
    it 'should be able to GET new user as @user' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:user).should be_a(User)
    end
    it "should create with the minimum valid parameters" do
      @num_users = User.count
      post :create, :user => FactoryGirl.attributes_for(:user_min_create_attr)
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should be_instance_of(User) 
      assigns(:user).should be_persisted
      assigns(:user).username.should eq(FactoryGirl.attributes_for(:user_min_create_attr)[:username])
      response.should render_template("show")
      User.count.should == (@num_users+1)
    end
    it 'should not create user missing any one of the minimum_attributes' do
      FactoryGirl.attributes_for(:user_min_create_attr).each do |key, value|
        test_attributes = FactoryGirl.attributes_for(:user_min_create_attr)
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        FactoryGirl.attributes_for(:user_min_create_attr).size.should == (test_attributes.size+1)
        @num_users = User.count
        post :create, :user => test_attributes
        response.should render_template("new")
        User.count.should == (@num_users)
      end
    end
    it 'should create user with each of the safe parameters' do
      FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
        @num_users = User.count
        post :create, :user => FactoryGirl.attributes_for(:users_create).merge({key => value})
        assigns(:user).should_not be_nil
        assigns(:user).should be_instance_of(User)
        assigns(:user)[key].should == value
        User.count.should == (@num_users+1)
      end
    end
    it "should ignore unsafe parameters in create user" do
      FactoryGirl.attributes_for(:user_unsafe_attr).each do |key, value|
        @num_users = User.count
        post :create, :user => FactoryGirl.attributes_for(:users_create).merge({key => value})
        assigns(:user).should_not be_nil
        assigns(:user)[key].should_not == value
        User.count.should == (@num_users+1)
      end
    end
    it "should ignore any of the bad_attributes when creating a user" do
      FactoryGirl.attributes_for(:user_inval_attr).each do |key, value|
        @num_users = User.count
        post :create, :user => FactoryGirl.attributes_for(:users_create).merge({key => value})
        assigns(:user).should_not be_nil
        assigns(:user)[key].should_not == value
        User.count.should == (@num_users+1)
      end
    end
    it 'should not create a user with mismatched password' do
      @num_users = User.count
      post :create, :user => FactoryGirl.attributes_for(:users_create).merge({:password_confirmation => 'not_the_password'})
      User.count.should == (@num_users)
      assigns(:user).should_not be_nil
      assigns(:user).should be_instance_of(User) 
      assigns(:user).should_not be_persisted
      response.should render_template("new")
    end
    it 'should be able to GET edit another user as @user' do
      user = FactoryGirl.create(:user_min_create_attr)
      get :edit, :id => user.id.to_s
      response.should be_success
      response.should render_template('/edit')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(user)
    end
    it 'should be able to PUT update with valid params - ' do
      user = FactoryGirl.create(:user_min_create_attr)
      put :update, :id => user.id, :user => FactoryGirl.attributes_for(:user_min_create_attr).merge({:first_name => 'Joe'})
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).first_name.should == 'Joe'
      assigns(:user).should be_persisted
      updated_user = User.find(user.id)
      updated_user.should_not be_nil
      updated_user.username.should eq(FactoryGirl.attributes_for(:user_min_create_attr)[:username])
      response.should render_template("show")
    end
    it 'should not be able to PUT update with invalid params - ' do
      user = FactoryGirl.create(:user_min_create_attr)
      FactoryGirl.attributes_for(:user_inval_attr).each do |key, value|
        put :update, :id => user.id, :user => FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value})
        assigns(:user).should_not be_nil
        assigns(:user)[key].should_not == value
        updated_user = User.find(user.id)
        updated_user.should eq(user)
        response.should render_template('show')
      end
    end
    it 'should be able to PUT update roles from the VALID_ROLES app_constant' do
      user = FactoryGirl.create(:user_min_create_attr)
      VALID_ROLES.each do |role|
        put :update, :id => user.id, :user => {:roles => role}
        assigns(:user).should_not be_nil
        assigns(:user).should be_a(User)
        # Rails.logger.debug("T users_controller_spec - valid_role:#{role.to_s}")
        assigns(:user).has_role?(role).should be_true
        updated_user = User.find(user.id)
        updated_user.should_not be_nil
        # Rails.logger.debug("has_role?(#{role})")
        updated_user.has_role?(role).should be_true
        response.should render_template("show")
      end
    end
    it 'should not be able to PUT update roles not in the VALID_ROLES app_constant' do
      user = FactoryGirl.create(:user_min_create_attr)
      put :update, :id => user.id, :user => {:roles => %w{ bad_role }}
      # assigns(:user).errors.count.should > 0  # error doesn't create an empty user
      assigns(:user).has_role?('bad_role').should be_false
      updated_user = User.find(user.id)
      updated_user.should_not be_nil
      updated_user.has_role?('bad_role').should be_false
      # response.should render_template("edit")
      response.should render_template("show") # not an error, bad roles are just ignored (for now? )
    end
    it 'should be able to GET show and another user as @user' do
      user = FactoryGirl.create(:user_min_create_attr)
      get :show, :id => user.id.to_s
      response.should be_success
      response.should render_template('/show')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(user)
      assigns(:user).deactivated?.should be_false
    end
    it 'should see the errors page on an ActiveRecord error' do
      get :show, :id => 0
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
  end

  
  context 'logged in regular user (maint_users) - for other users - ' do
    
    before(:each) do
      @me = FactoryGirl.create(:reg_user_full_create_attr)
      @my_session = session_signin(FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username], FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password])
    end

    it 'should not be able to GET the index page (not see a listing of all users)' do
      user = FactoryGirl.create(:user_min_create_attr)
      get :index
      response.should_not be_success
      response.code.should be == '302'
      response.should be_redirect
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to GET new user as @user' do
      get :new
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to POST create' do
      expect {
        post :create, :user => FactoryGirl.attributes_for(:user_min_create_attr)
      }.to change(User, :count).by(0)
      post :create, :user => FactoryGirl.attributes_for(:user_min_create_attr)
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to GET edit user (not be able to edit other users)' do
      user = FactoryGirl.create(:user_full_create_attr)
      get :edit, :id => user.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to PUT update user (not be able to edit other users)' do
      user = FactoryGirl.create(:user_min_create_attr)
      put :update, :id => user.id, :user => (FactoryGirl.attributes_for(:user_min_create_attr)).merge(FactoryGirl.attributes_for(:user_safe_attr))
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to GET show user (not be able to view other users)' do
      user = FactoryGirl.create(:user_min_create_attr)
      get :show, :id => user.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end

    it 'should not be able to navigate to the DELETE destroy page for user' do
      user = FactoryGirl.create(:user_min_create_attr)
      delete :destroy, :id => user.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    
  end


  context 'logged in regular user (maint_users) - for self - ' do

    before(:each) do
      @me = FactoryGirl.create(:reg_user_full_create_attr)
      @my_session = session_signin(FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username], FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password])
    end

    it 'should not be able to DELETE destroy self' do
      delete :destroy, :id => @me.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should be able to GET edit self' do
      get :edit, :id => @me.id.to_s
      response.should be_success
      response.should render_template('users/edit')
      assigns(:user).should eq(@me)
    end
    it 'should be able to PUT update self' do
      put :update, :id => @me.id, :user => (FactoryGirl.attributes_for(:reg_user_min_create_attr)).merge(FactoryGirl.attributes_for(:user_safe_attr))
      response.should be_success
      response.should render_template('users/show')
      assigns(:user).should eq(@me)
    end
    it 'should not be able to PUT update user roles (not be allowed to assign roles) for self' do
      put :update, :id => @me.id, :user => (FactoryGirl.attributes_for(:reg_user_min_create_attr)).merge(FactoryGirl.attributes_for(:user_roles_attr))
      response.should render_template('users/edit')
    end
    it 'should be able to GET show self' do
      get :show, :id => @me.id
      response.should be_success
      response.should render_template('users/show')
      assigns(:user).should eq(@me)
    end
    
    context 'should allow the users to view their own information' do
      it 'should view the content from the Users Show page' do
        get :show, :id => @me.id
        response.should be_success
        response.should render_template('/show')
        assigns(:user).should_not be_nil
        assigns(:user).should be_a(User)
        assigns(:user).should eq(@me)
      end
    end
    it 'should allow the user to update_passwords (for themself) with good old password and matching new passwords' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      put :update_password, :id => @me.id, :user => FactoryGirl.attributes_for(:reg_user_update_password_attr)
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('show')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(@me.username)
      # assigns(:user).has_password?(FactoryGirl.attributes_for(:user_update_password_attr)[:password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(@me.username)
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:password]).should be_true
    end
    
    it 'should not allow the user to update_passwords (for themself) with bad old password' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      put :update_password, :id => @me.id, :user => FactoryGirl.attributes_for(:reg_user_update_password_attr).merge({:old_password => 'bad_value'})
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(@me.username)
      assigns(:user).has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(@me.username)
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
    end
    
    it 'should not allow the user to update_passwords (for themself) with mismatched new passwords' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      put :update_password, :id => @me.id, :user => FactoryGirl.attributes_for(:reg_user_update_password_attr).merge({:password => 'bad_value'})
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(@me.username)
      assigns(:user).has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(@me.username)
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
    end
    
    it 'should allow the user to update (for themself) with no password information (password untouched)' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      # update with a full set of attributes, less any password fields
      attribs = FactoryGirl.attributes_for(:reg_user_min_create_attr).merge( FactoryGirl.attributes_for(:user_safe_attr))
      attribs.delete(:password)
      attribs.delete(:password_confirmation)
      attribs.delete(:old_password)
      # attribs.should == {:email=>"email@example.com", :username=>"TestUser", :first_name=>"Test", :last_name=>"User"}
      put :update, :id => @me.id, :user => attribs
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('show')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(FactoryGirl.attributes_for(:user_safe_attr)[:username])
      assigns(:user).has_password?(FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(FactoryGirl.attributes_for(:user_safe_attr)[:username])
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password]).should be_true
    end
    
    it 'should allow the user to change passwords in update with good old password and matching new passwords' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      put :update, :id => @me.id, :user => FactoryGirl.attributes_for(:reg_user_update_password_attr).merge( FactoryGirl.attributes_for(:user_safe_attr) )
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('show')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(FactoryGirl.attributes_for(:user_safe_attr)[:username])
      # assigns(:user).has_password?(FactoryGirl.attributes_for(:user_update_password_attr)[:password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(FactoryGirl.attributes_for(:user_safe_attr)[:username])
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:password]).should be_true
    end
    
    it 'should not allow the user to change passwords in update with bad old password' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      put :update_password, :id => @me.id, :user => FactoryGirl.attributes_for(:reg_user_update_password_attr).merge( \
        FactoryGirl.attributes_for(:user_safe_attr).merge({:old_password => 'bad_value'}) )
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('edit')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(@me.username)
      assigns(:user).has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(@me.username)
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
    end
    
    it 'should not allow the user to change passwords in update with mismatched new passwords' do
      # user = FactoryGirl.create(:user_min_create_attr)
      get :edit_password, :id => @me.id
      response.should be_success
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).should eq(@me)
      put :update_password, :id => @me.id, :user => FactoryGirl.attributes_for(:reg_user_update_password_attr).merge( \
        FactoryGirl.attributes_for(:user_safe_attr).merge({:password => 'bad_value'}) )
      response.should be_success
      response.should_not render_template(home_errors_path)
      response.should render_template('edit_password')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).username.should eq(@me.username)
      assigns(:user).has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
      updated_user = User.find(@me.id)
      updated_user.username.should eq(@me.username)
      updated_user.has_password?(FactoryGirl.attributes_for(:reg_user_update_password_attr)[:old_password]).should be_true
    end
    
  end
  
  describe "routing" do
    it "routes to #index" do
      { :get => '/users' }.should route_to("users#index")
    end
    it "routes to #show" do
      { :get => '/users/1' }.should route_to("users#show", :id => "1")
    end
    it "routes to #new" do
      { :get => '/users/new' }.should route_to("users#new")
    end
    it "routes to #create" do
      { :post => '/users' }.should route_to("users#create")
    end
    it "routes to #edit" do
     { :get => '/users/1/edit' }.should route_to("users#edit", :id => "1")
    end
    it "routes to #update" do
      { :put => '/users/1' }.should route_to("users#update", :id => "1")
    end
    it "routes to #destroy" do
      { :delete => '/users/1' }.should route_to("users#destroy", :id => "1")
    end
    it "routes to #deactivate" do
      { :put => '/users/1/deactivate' }.should route_to("users#deactivate", :id => "1")
    end
    it "routes to #destroy" do
      { :put => '/users/1/reactivate' }.should route_to("users#reactivate", :id => "1")
    end
    it "routes to #destroy" do
      { :get => '/users/1/edit_password' }.should route_to("users#edit_password", :id => "1")
    end
    it "routes to #destroy" do
      { :put => '/users/1/update_password' }.should route_to("users#update_password", :id => "1")
    end
    #it "routes to #destroy" do
    #  { :put => '/users/1/reset_password' }.should route_to("users#reset_password", :id => "1")
    #end
  end
end
