require 'spec_helper'
include UserTestHelper
require 'capybara_spec_helper'
include ApplicationHelper


describe HomeController do
  
  before(:each) do
    clear_session
  end

  context 'all users -' do
    it 'should be able to navigate to the GET index page' do
      get :index
      response.should be_success
      response.code.should be == '200'
      response.should render_template("index")
    end
    
    it 'should be able to navigate to the GET about page' do
      get :about
      response.should be_success
      response.code.should be == '200'
      response.should render_template("about")
    end
    
    it 'should be able to navigate to the GET contact page' do
      get :contact
      response.should be_success
      response.code.should be == '200'
      response.should render_template("contact")
    end
    
    it 'should be able to navigate to the GET errors page' do
      get :errors
      response.should be_success
      response.code.should be == '200'
      response.should render_template("errors")
    end
    
    it 'should be able to navigate to the GET news page' do
      get :news
      response.should be_success
      response.code.should be == '200'
      response.should render_template("news")
    end
    
    it 'should be able to navigate to the GET status page' do
      get :status
      response.should be_success
      response.code.should be == '200'
      response.should render_template("status")
    end
    
    it 'should be able to navigate to the GET help page' do
      get :help
      response.should be_success
      response.code.should be == '200'
      response.should render_template("help")
    end
    
  end
  
  context 'not logged in (guest user) -' do
    it 'should not be able to navigate to the GET site_map page' do
      get :site_map
      response.should_not be_success
      response.code.should be == '302'
      response.should be_redirect
      response.should redirect_to('/signin')
      assigns(:user_session).should_not be_nil
      #assigns(:session).current_user.should_not be_nil
      assigns(:user_session).current_user_id.should == 0
      assigns(:user_session).signed_in?.should be_false
    end
  end

  context 'logged in user -' do
    it 'should be able to navigate to the GET site_map page' do
      test_user = FactoryGirl.create(:user_min_create_attr)
      session_signin(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      get :index
      response.should be_success
      response.code.should be == '200'
      response.should render_template("index")
      assigns(:user_session).should_not be_nil
      assigns(:user_session).signed_in?.should be_true
      get :site_map
      response.should be_success
      response.code.should be == '200'
      response.should render_template("site_map")
      assigns(:user_session).should_not be_nil
      assigns(:user_session).signed_in?.should be_true
    end
  end
  
end
