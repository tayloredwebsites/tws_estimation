require 'spec_helper'
require 'capybara_spec_helper'

describe 'Home Integration Tests' do
	context "visit root_path/home_index/Home#index page" do
		before(:each) do
			visit home_index_path
		end
    it "should find the title css with the Company Name from the App Config file" do
      find('title').should have_content('Taylored Web Sites - Home')
    end
    it "should find the content from the home index page (app/views/home/index.html.erb)" do
      find('h4').should have_content('Application Configuration Constants')
    end
	end

	context "visit home_help/Home#help page" do
		before(:each) do
			visit home_help_path
		end
    it "should find the title css with the Company Name from the App Config file" do
      find('title').should have_content('Taylored Web Sites - Help')
    end
    it "should find the content from the home index page (app/views/home/index.html.erb)" do
      find('h4').should have_content('Home#help')
    end
	end

end
