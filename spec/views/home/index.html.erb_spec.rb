require 'spec_helper'
require 'capybara_spec_helper'

describe "home/index.html.erb" do
	before(:each) do
		render
	end
	it "should not have the title selector" do
		rendered.should_not have_selector("title")
	end
	it "should not have the title selector with content" do
		rendered.should_not have_selector("title", :text => 'Taylored Web Sites - Home')
	end
	it "should find the header tag content" do
		rendered.should have_selector('h4', :text => "Application Configuration Constants")
	end
	it "should find a span selector with content" do
		rendered.should have_selector('span.label', :text => 'Environment')
	end
	it "should find a span selector with content" do
		rendered.should have_selector('span.value', :text => 'Testing')
	end
	it "should find a span selector with content" do
		rendered.should have_selector('span', :text => 'APP_NAME')
	end
	it "should not find a span selector with garbage" do
		rendered.should_not have_selector('span', :text => 'xxxx')
	end
end
