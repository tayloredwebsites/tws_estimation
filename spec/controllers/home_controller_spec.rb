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
    it 'should not be able to navigate to the GET site_map page'
  end

  context 'logged in user -' do
    it 'should be able to navigate to the GET site_map page'
  end
  
end
