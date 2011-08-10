require 'spec_helper'
require 'capybara_spec_helper'

describe "Application Layout Links tests (capybara)" do

  context 'visit home_index page' do

    homeIndexTitle = I18n.translate('home.index.title')
    homeHelpTitle = I18n.translate('home.help.title')

    before(:each) do
      visit home_index_path
      # save_and_open_page		# works with visit (not with get)
    end

    it "should start at the Home page" do
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
    end
    it 'should go to help page when top nav help link is clicked' do
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
      find('ul#header_nav_bar').find('a', :text => 'Help').click
      find('#header_tagline_page_title').text.should =~ /^#{homeHelpTitle}$/
    end
    it 'should go to the home page when the logo is clicked' do
      # first go to help page
      find('ul#header_nav_bar').find('a', :text => 'Help').click
      # confirm at help page
      find('#header_tagline_page_title').text.should =~ /^#{homeHelpTitle}$/
      # click on logo
      find(:xpath, '//img[@alt="home page"]/parent::a').click
      # confirm at home page
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
    end
    it 'should go to help page when left nav help link is clicked' do
      # first go to help page
      find('div#left_content').find('a', :text => 'Help').click
      # confirm at help page
      find('#header_tagline_page_title').text.should =~ /^#{homeHelpTitle}$/
    end
  end
end
