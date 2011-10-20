require 'spec_helper'
require 'capybara_spec_helper'

describe HomeController do
  
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
      assigns(:session).should_not be_nil
      assigns(:session).current_user.should_not be_nil
      assigns(:session).current_user.id.should be_nil
    end
  end

  context 'logged in user -' do
    it 'should be able to navigate to the GET site_map page' do
      FactoryGirl.create(:user_min_create_attr)
      assigns(:session).should_not be_nil
      assigns(:session).current_user.should_not be_nil
      assigns(:session).current_user.id.should be_nil
      assigns(:session).sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      assigns(:session).current_user.id.should_not be_nil
      get :site_map
      response.should be_success
      response.code.should be == '200'
      response.should render_template("site_map")
      assigns(:session).should_not be_nil
      assigns(:session).current_user.should_not be_nil
      assigns(:session).current_user.id.should_not be_nil
    end
  end
  
end
