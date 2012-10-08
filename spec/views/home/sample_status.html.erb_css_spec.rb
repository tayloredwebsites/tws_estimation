require 'spec_helper'
# require 'capybara_spec_helper'

describe "home/status.html.erb" do

  appName = I18n.translate('app_name')
  companyName = I18n.translate('company_name')
  pageTitle = I18n.translate('home.status.title')
  pageHeader = I18n.translate('home.status.header')

  before(:each) do
    render
  end
  describe "Home Status view test - " do
    context "page content - " do
      it "should find the header tag" do
        rendered.should have_selector('h4')
      end
      it "should find the header tag content" do
        rendered.should have_selector('h4', :text => pageHeader)
      end
      it "should find a span selector with content" do
        rendered.should have_selector('div.field[1]/span.label', :text => 'Environment')
      end
      it "should find via xpath a span selector with content" do
        rendered.should have_selector(:xpath, '//div[@class="field"][1]/span[@class="label"]', :text => 'Environment')
      end
      it "should find a span selector with content" do
        rendered.should have_selector('div.field[1]/span.value', :text => ::Rails.env)
      end
      it "should find a span selector with content" do
        rendered.should have_selector('div.field[2]/span.label', :text => 'APP_NAME')
      end
      it "should not find a span selector with garbage" do
        rendered.should have_selector('div.field[2]/span.value', :text => appName)
      end
      it "should not find a span selector with garbage" do
        rendered.should_not have_selector('div.field[2]/span.value', :text => 'xxxx')
      end
    end
  end
end
