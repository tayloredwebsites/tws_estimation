require 'spec_helper'
include UserTestHelper
include ApplicationHelper


describe UsersController do

  before(:each) do
    clear_session
  end
  
  context 'not logged in (guest user) -' do
    it 'should not be able to PUT deactivate an active user' do
      @user1 = FactoryGirl.create(:reg_user_min_create_attr)
      @user1.deactivated?.should be_false
      put :deactivate, :id => @user1.id
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
    it 'should not be able to PUT reactivate an deactivated user' do
      @user1 = FactoryGirl.create(:reg_user_min_create_attr)
      @user1.deactivated?.should be_false
      @user1.deactivate
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      put :reactivate, :id => @user1.id
      response.should redirect_to(:controller => 'users_sessions', :action => 'signin')
    end
                        
  end
  
  context 'logged in admin user -' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
    end
    
    it 'should be able to PUT deactivate an active user' do
      @user1 = FactoryGirl.create(:user_min_create_attr)
      @user1.deactivated?.should be_false
      put :deactivate, :id => @user1.id
      response.should be_success
      response.code.should be == '200'
      response.should_not redirect_to(:controller => 'home', :action => 'errors')
      response.should render_template("index")
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the user we deactivate
      Rails.logger.debug("T* create :user_min_create_attr")
      @user1 = FactoryGirl.create(:user_min_create_attr)
      Rails.logger.debug("T* deactivated? should be false")
      @user1.deactivated?.should be_false
      Rails.logger.debug("T* deactivate")
      @user1.deactivate
      @user1.errors.count.should be == 0
      @updated_user = User.find(@user1.id)
      Rails.logger.debug("T* deactivated? should be true")
      @updated_user.deactivated?.should be_true
      Rails.logger.debug("T* put deactivate #{@user1.id.inspect.to_s}")
      put :deactivate, :id => @user1.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:user).errors.count.should be > 0
      assigns(:user).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:user).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the user we deactivate
      @user1 = FactoryGirl.create(:user_min_create_attr)
      @user1.deactivated?.should be_false
      @user1.deactivate
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      put :reactivate, :id => @user1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:user).errors.count.should be == 0
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).deactivated?.should be_false
      response.should render_template("show")
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated users
      @user1 = FactoryGirl.create(:user_min_create_attr)
      @user1.deactivated?.should be_false
      put :reactivate, :id => @user1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:user).errors.count.should be > 0
      assigns(:user).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:user).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:user).should_not be_nil
      assigns(:user).should be_a(User)
      assigns(:user).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      @user_count = User.count
      user = FactoryGirl.create(:user_min_create_attr)
      User.count.should == @user_count + 1
      user.deactivated?.should be_false
      delete :destroy, :id => user.id
      assigns(:user).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:user).should be_a(User)
      assigns(:user).should eq(user)
      User.count.should == @user_count + 1
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      Rails.logger.debug("T users_controller_spec Test destroy show deactivated false - Index")
      get :index, :show_deactivated => "false" # set show deactivated session flag so we can see deactivated users
      user = FactoryGirl.create(:user_min_create_attr)
      user.deactivate
      user.errors.count.should == 0
      @user_count = User.count
      Rails.logger.debug("T users_controller_spec Test destroy show deactivated false - Destroy")
      delete :destroy, :id => user.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      @user_count.should == User.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated users
      user = FactoryGirl.create(:user_min_create_attr)
      user.deactivate
      user.errors.count.should == 0
      @user_count = User.count
      delete :destroy, :id => user.id
      response.should render_template('/index')
      @user_count.should == User.count+1
    end
    it 'should be able to set and clear the show_deactivated flag (user count should be reflected)' do
      user = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      user.deactivate
      user.errors.count.should == 0
      User.count.should == 2
      get :index  # confirm that default startup is to not show deactivated
      response.should be_success
      response.should render_template('/index')
      assigns(:users).size.should  == 1
      User.count.should == 2
      get :index, :show_deactivated => DB_TRUE.to_s
      response.should be_success
      response.should render_template('/index')
      User.count.should == 2
      assigns(:users).size.should  == 2
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      User.count.should == 2
      assigns(:users).size.should  == 2
      get :index, :show_deactivated => DB_FALSE.to_s
      response.should be_success
      response.should render_template('/index')
      User.count.should == 2
      assigns(:users).size.should  == 1
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      User.count.should == 2
      assigns(:users).size.should  == 1
    end
  end

  
  context 'logged in regular user (maint_users) - for other users - ' do
    
    before(:each) do
      @me = FactoryGirl.create(:reg_user_full_create_attr)
      @my_session = session_signin(FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username], FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password])
    end

    it 'should not be able to PUT deactivate an active user' do
      @user1 = FactoryGirl.create(:user_min_create_attr)
      @user1.deactivated?.should be_false
      put :deactivate, :id => @user1.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to PUT reactivate an deactivated user' do
      @user1 = FactoryGirl.create(:user_min_create_attr)
      @user1.deactivated?.should be_false
      @user1.deactivate
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      put :reactivate, :id => @user1.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
  end


  context 'logged in regular user (maint_users) - for self - ' do

    before(:each) do
      @me = FactoryGirl.create(:reg_user_full_create_attr)
      @my_session = session_signin(FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username], FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password])
    end

    it 'should not be able to PUT deactivate self' do
      @me.deactivated?.should be_false
      put :deactivate, :id => @me.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
    it 'should not be able to PUT reactivate self' do
      @me.deactivated?.should be_false
      @me.deactivate
      @updated_user = User.find(@me.id)
      @updated_user.deactivated?.should be_true
      put :reactivate, :id => @me.id
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
  end
  
end
