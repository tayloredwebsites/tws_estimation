require 'spec_helper'
include UserTestHelper
include ApplicationHelper


describe UsersSessionsController do

  before(:each) do
    clear_session
  end

  describe "GET 'signin'" do
    it "should be successful" do
      get :signin
      response.should be_success
      response.should render_template('/signin')
      assigns(:user_session).should_not be_nil
    end
  end

  describe "POST create" do
    
    before(:each) do
      FactoryGirl.create(:user_min_create_attr)
    end
    
    describe "with valid params - " do

      before(:each) do
        post :create, :user_session => FactoryGirl.attributes_for(:user_session)
      end
      
      it "should successfully render the user session created page" do
        response.should be_success
        response.should render_template('users_sessions/create')
      end
      
      it "should return the current_user" do
        assigns(:user_session).current_user.should_not be_nil
        assigns(:user_session).current_user.should be_a(User)
        assigns(:user_session).current_user.should be_persisted
        assigns(:user_session).current_user.id.should_not be_nil
        assigns(:user_session).current_user.username.should eq(FactoryGirl.attributes_for(:user_session)[:username])
      end
      
      it 'should be signed_in?' do
        assigns(:user_session).should_not be_nil
        assigns(:user_session).signed_in?.should be_true
        assigns(:user_session).should_not be_nil
      end

    end

    describe "with invalid params - " do

      before(:each) do
        post :create, :user_session => FactoryGirl.attributes_for(:invalid_user_session)
      end
      
      it "should redirect the user back to the login page" do
        response.should be_redirect
        response.should redirect_to(signin_path)
      end

      it "should not return the current_user" do
        #assigns(:user_session).current_user.should_not be_nil
        assigns(:user_session).current_user_id.should be_nil
      end

      it 'should not be signed_in?' do
        assigns(:user_session).should_not be_nil
        assigns(:user_session).current_user_id.should be_nil
        #assigns(:suser_ession).signed_in?.should be_false
      end

    end
  end

  context 'all users -' do
    it 'should be able to navigate to the POST create page' do
      FactoryGirl.create(:user_min_create_attr)
      post :create, :user_session => FactoryGirl.attributes_for(:user_session)
      response.should be_success
      response.code.should be == '200'
      response.should render_template("create")
    end
    
    it 'should be able to navigate to the GET signin page' do
      get :signin
      response.should be_success
      response.code.should be == '200'
      response.should render_template("/signin")
    end
    
  end
  
  context 'not logged in (guest user) -' do
    it 'should not be able to the signout action if not signed in' do
#      FactoryGirl.create(:user_min_create_attr)
      get :signin
      response.should be_success
      response.code.should be == '200'
      response.should render_template("/signin")
      assigns(:user_session).should_not be_nil
      #assigns(:user_session).current_user.should_not be_nil
      assigns(:user_session).current_user_id.should be_nil
      assigns(:user_session).signed_in?.should be_false
      put :signout  #, FactoryGirl.attributes_for(:user_session)[:id]
      response.should_not be_success
      response.code.should be == '302'
      response.should be_redirect
      response.should redirect_to('/signin')
      assigns(:user_session).should_not be_nil
      #assigns(:user_session).current_user.should_not be_nil
      assigns(:user_session).current_user_id.should be_nil
    end
  end
  
  context 'logged out user -' do
    
    it 'should not be able to do the signout action on an invalid user session' do
      FactoryGirl.create(:user_min_create_attr)
      post :signout #, -9999
      response.should_not be_success
      response.code.should be == '302'
      response.should be_redirect
      response.should redirect_to('/signin')
      assigns(:user_session).should_not be_nil
      #assigns(:user_session).current_user.should_not be_nil
      assigns(:user_session).current_user_id.should be_nil
    end

  end

  
  context 'logged in user -' do
    
    before(:each) do
      FactoryGirl.create(:user_min_create_attr)
      post :create, :user_session => FactoryGirl.attributes_for(:user_session)
      response.should be_success
      response.code.should be == '200'
      response.should render_template("create")
    end
    
    it 'should be able to do the signout action' do
      post :signout #, FactoryGirl.attributes_for(:user_session)[:id]
      response.should be_success
      response.code.should be == '200'
      response.should render_template('/signout')
      assigns(:user_session).should_not be_nil
      #assigns(:user_session).current_user.should_not be_nil
      assigns(:user_session).current_user_id.should be_nil
      response.should be_success
    end
    
  end

end
