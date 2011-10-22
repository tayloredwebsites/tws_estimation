require 'spec_helper'
require 'capybara_spec_helper'
include ApplicationHelper


describe HomeController do
#  render_views

  before(:each) do
    clear_session
  end

  context "Mock tests - " do 
	
    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end
	
    describe "GET 'help'" do
      it "should be successful" do
        get 'help'
        response.should be_success
      end
    end

  end
	
end
