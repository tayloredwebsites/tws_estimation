require 'spec_helper'
require 'capybara_spec_helper'

describe "home/help.html.erb" do
	before(:each) do
		render
	end
	#it "should find the header tag content" do	# use have_selector :text option as below)
	#	rendered.should have_content("Test#")
	#end
	#it "should have the content" do	# use have_selector :text option as below)
	#	rendered.should have_content('Update me in app/views/home/help.html.erb')
	#end
	it "should not have the title selector" do
		rendered.should_not have_selector("title")
	end
	it "should not have the title selector with content" do
		rendered.should_not have_selector("title", :text => 'Taylored Web Sites - Home')
	end
	it "should find a span selector with content" do
		rendered.should have_selector('span', :text => 'Update me in app/views/home/help.html.erb')
	end
	it "should find the header tag content" do
		rendered.should have_selector('h4', :text => "Test#")	# When testing controller_name.capitalize#action_name don't match development
	end
	it "should not find a span selector with garbage" do
		rendered.should_not have_selector('span', :text => 'xxxx')
	end
end
