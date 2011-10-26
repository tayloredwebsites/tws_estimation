require 'spec_helper'
require 'capybara_spec_helper'

describe "Layout Links tests" do

  context 'visit home_index page' do

    homeIndexTitle = I18n.translate('home.index.title')
    homeHelpTitle = I18n.translate('home.help.title')
    usersTitle = I18n.translate('users.title')

    before(:each) do
      visit home_index_path
      # save_and_open_page		# works with visit (not with get)
    end

    it "should start at the Home page" do
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
    end
    it 'should go to Users index page when top nav Users link is clicked' do
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
      find('ul#header_nav_bar').find('a', :text => I18n.translate('users.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should go to help page when top nav help link is clicked' do
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
      find('ul#header_nav_bar').find('a', :text => homeHelpTitle).click
      find('#header_tagline_page_title').text.should =~ /^#{homeHelpTitle}$/
    end
    it 'should go to Users index page when left nav Users link is clicked' do
      find('div#left_content').find('a', :text => I18n.translate('users.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should go to help page when left nav help link is clicked' do
      find('div#left_content').find('a', :text => homeHelpTitle).click
      find('#header_tagline_page_title').text.should =~ /^#{homeHelpTitle}$/
    end
    it 'should go to the home page when the logo is clicked' do
      # first go to help page
      find('ul#header_nav_bar').find('a', :text => homeHelpTitle).click
      # confirm at help page
      find('#header_tagline_page_title').text.should =~ /^#{homeHelpTitle}$/
      # click on logo
      find(:xpath, "//img[@alt=\"#{homeIndexTitle}\"]/parent::a").click
      # confirm at home page
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
    end
    it 'should go to the About page when the footer about link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.about.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.about.title')}$/
    end		
    it 'should go to the Contact page when the footer contact link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.contact.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.contact.title')}$/
    end	
    it 'should go to the News page when the footer news link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.news.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.news.title')}$/
    end			
    # see spec/integration/users_authentication_spec.rb for signed in tests
    it 'should not go to the Site map page when the footer site map link is clicked (goes to signin page)' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('home.site_map.title')}$/
      find('div.module_header/a', :text => I18n.translate('users_sessions.signin.title'))
    end			
    it 'should go to the Status page when the footer status link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.status.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.status.title')}$/
    end	
    it 'should go to the Help page when the footer help link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.help.title')}$/
    end	
  end
end
