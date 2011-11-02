require 'spec_helper'
include UserTestHelper
require 'capybara_spec_helper'

describe "Layout Links tests - " do

  context 'visit home_index page - ' do

    before(:each) do
      visit home_index_path
      # save_and_open_page		# works with visit (not with get)
    end

    it "should start at the Home page" do
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
    end
    it 'should go to help page when top nav help link is clicked' do
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
      find('ul#header_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.help.title')}$/
    end
    it 'should go to help page when left nav help link is clicked' do
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
      find('div#left_content').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.help.title')}$/
    end
    it 'should go to the home page when the logo is clicked' do
      # first go to help page
      find('ul#header_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      # confirm at help page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.help.title')}$/
      # click on logo
      find(:xpath, "//img[@alt=\"#{I18n.translate('home.index.title')}\"]/parent::a").click
      # confirm at home page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
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
    it 'should go to the Status page when the footer status link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.status.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.status.title')}$/
    end	
    it 'should go to the Help page when the footer help link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.help.title')}$/
    end	
  end
  
  context 'Guest User (not logged in) - visit Home Index page -  ' do
    before(:each) do
      visit home_index_path
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
      find('div.module_header/a', :text => I18n.translate('users_sessions.signin.action'))
    end
    it 'should not go to Users index page when not signed in user clicks top nav Users link' do
      find('ul#header_nav_bar').find('a', :text => I18n.translate('users.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should go to Users index page when left nav Users link is clicked' do
      find('div#left_content').find('a', :text => I18n.translate('users.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should not go to the Site map page when the footer site map link is clicked (goes to signin page)' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('home.site_map.title')}$/
    end	
  end

  context 'Logged in User - visit Home Index page -  ' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      find('div.module_header/a').text.should =~ /#{I18n.translate('users_sessions.signout.action')}/
    end
    it 'should go to Users index page when user clicks top nav Users link' do
      visit home_index_path
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
      find('ul#header_nav_bar').find('a', :text => I18n.translate('users.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should go to the Site map page when the footer site map link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.site_map.title')}$/
    end			
  end
end
