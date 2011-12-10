require 'spec_helper'
# require 'capybara_spec_helper'

describe "home/help.html.erb" do

  context 'Home Help view test' do
    before(:each) do
      render
    end
    
    it "should find the header tag content" do
      rendered.should have_xpath('//h4', :text => I18n.translate('home.help.header'))
    end
    
  end

end
