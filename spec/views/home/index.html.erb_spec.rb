require 'spec_helper'
require 'capybara_spec_helper'

describe "home/index.html.erb" do

  before(:each) do
    render
  end
  describe "Home Index view test - " do
    context "page content - " do
      it "should find the header tag content" do
        rendered.should have_selector('h4', :text => I18n.translate('home.index.header'))
      end
    end
  end
end
