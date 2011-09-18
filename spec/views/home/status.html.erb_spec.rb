require 'spec_helper'
require 'capybara_spec_helper'

describe "home/status.html.erb" do

  describe "Home Status view test - " do

    before(:each) do
      render
    end

    it "should find the header tag content" do
      rendered.should have_xpath('//h4', :text => I18n.translate('home.status.header'))
    end
    it "should find a span selector with content" do
      rendered.should have_xpath('//div[1][@class="field"]/span[@class="label"]', :text => 'Environment')
    end
    it "should find a span selector with content" do
      rendered.should have_xpath('//div[1][@class="field"]/span[@class="value"]', :text => ::Rails.env)
    end
    it "should find a span selector with content" do
      rendered.should have_xpath('//div[2][@class="field"]/span[@class="label"]', :text => 'APP_NAME')
    end
    it "should not find a span selector with garbage" do
      rendered.should have_xpath('//div[2][@class="field"]/span[@class="value"]', :text => I18n.translate('app_name'))
    end
    it "should not find a span selector with garbage" do
      rendered.should_not have_xpath('//div[2][@class="field"]/span[@class="value"]', :text => 'sasdfljk')
    end
  end
end
