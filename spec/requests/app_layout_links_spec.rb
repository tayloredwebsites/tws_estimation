require 'spec_helper'

describe "AppLayoutLinks" do
  context 'rspec tests' do
    it "should have a home page at home_index_path" do
      get home_index_path
      response.status.should be(200)
      response.should be_success
      #response.should redirect_to(:controller => 'home', :action => 'index')
      response.should render_template('home/index')
      response.body.should include("Home")
      response.body.should have_content('Home')
      response.body.should have_selector('title', :content => 'Home')
      response.body.should have_selector('title', :text => 'Home')
    end
  end
end
