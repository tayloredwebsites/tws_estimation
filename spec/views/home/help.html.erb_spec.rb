require 'spec_helper'
require 'capybara_spec_helper'

describe "home/help.html.erb" do

  appName = APP_CONFIG['APP_NAME']
  companyName = APP_CONFIG['COMPANY_NAME']
  pageTitle = I18n.translate('home.help.title')
  pageHeader = I18n.translate('home.help.header')

  before(:each) do
    render
  end
  describe "Home Index view test - " do
    context "page content - " do
      it "should find the header tag content" do
        rendered.should have_selector('h4', :text => pageHeader)
      end
      it "should find a span selector with content" do
        rendered.should have_selector('div.field[1]/span.label', :text => 'To Do')
      end
      it "should find a span selector with content" do
        rendered.should have_selector('div.field[1]/span.value', :text => 'Update me in app/views/home/help.html.erb')
      end
      it "should not find a span selector with garbage" do
        rendered.should_not have_selector('div.field[1]/span.value', :text => 'xxxx')
      end
    end
  end
end
