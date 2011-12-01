require 'spec_helper'
require 'capybara_spec_helper'

describe 'Layout Integration Tests - ' do

  context ' - Layout (common to all users) - ' do
    before(:each) do
      visit home_index_path
    end
    it 'should find the title with exactly correct content' do		# capybara find
      find('title').text.should =~ /^#{I18n.translate('config.company_name')} - #{I18n.translate('config.app_name')} - #{I18n.translate('home.index.title')}$/
    end
    it 'should find exactly matching company name' do		# capybara find
      find('#header_tagline_company_name').text.should =~ /^#{I18n.translate('config.company_name')}$/
    end
    it 'should find exactly matching app name' do		# capybara find
      find('#header_tagline_app_name').text.should =~ /^#{I18n.translate('config.app_name')}$/
    end
    it 'should not find all whitespace in the page title' do		# capybara find
      find('#header_tagline_page_title').text.should_not =~ /\A\s*\z/
    end
    it 'should find exactly matching page title from from app_config' do		# capybara find
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
    end
    it 'should not find all whitespace in the non-layout content' do		# capybara find
      find('div#content_body').text.should_not =~ /\A\s*\z/
    end
    it 'should have eMail in the upper left header' do
      find('div#header_logo_right').should have_content(I18n.translate('view_labels.email'))
    end
    it 'should have a help item in the top nav bar 6th item' do
      find('ul#header_nav_bar').find('li[6]/a').text.should =~ /\A#{I18n.translate('home.help.title')}\z/
    end
    it 'should not have Welcome in a left module header' do
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should_not =~
        /#{I18n.translate('view_labels.welcome_user', :user => '') }/
    end
    it 'should have a signin link in a left module header' do
      find('div.module_header/a', :text => I18n.translate('users_sessions.signin.title'))
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /^#{I18n.translate('users_sessions.signin.title') }$/
    end
    it 'should have a reset password link in a left module header' do
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signin.action')}/
    end
    it 'should have a help link in the left nav bar' do
      find('div#left_content').find('a', :text => I18n.translate('home.help.title'))
    end
    it 'should have empty header notice' do
      find('div#header_status').find('p.notice').text.should =~ /\A\s*\z/
    end
    it 'should have an empty footer notice' do
      find('div#footer_status').find('p.notice').text.should =~ /\A\s*\z/
    end
    it 'should have an empty footer alert' do
      find('div#footer_status').find('p.alert').text.should =~ /\A\s*\z/
    end

  end

  context ' - Layout (Guest users - not logged in) - ' do
    before(:each) do
      visit home_index_path
    end
    it 'should have a user item in the top nav bar 1st item' do
      find('ul#header_nav_bar').find('li[1]/a').text.should =~ /\A#{I18n.translate('users.show.title')}\z/
    end
  end
  
  context ' - Layout (Logged in Regular User) - ' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      visit home_index_path
    end
    it 'should have a user item in the top nav bar 1st item' do
      find('ul#header_nav_bar').find('li[1]/a').text.should =~ /\A#{I18n.translate('users.show.title')}\z/
    end
  end
  
  context ' - Layout (Logged in Admin User) - ' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      visit home_index_path
    end
    it 'should have a user item in the top nav bar 1st item' do
      find('ul#header_nav_bar').find('li[1]/a').text.should =~ /\A#{I18n.translate('users.title')}\z/
    end
    it 'should have a Users link in the left nav bar' do
      find('div#left_content').find('a', :text => I18n.translate('users.title'))
    end
  end


  context ' - Layout Links (common to all users) -' do

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
  
  context ' - Layout Links (Guest users - not logged in) - ' do
    before(:each) do
      visit home_index_path
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
      find('div.module_header/a', :text => I18n.translate('users_sessions.signin.action'))
    end
    it 'should not go to Users index page when top nav Users link is clicked' do
      find('ul#header_nav_bar').find('li[1]/a', :text => I18n.translate('users.show.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should not go to Users index page when left nav Users link is clicked' do
      find('div#left_content').find('li[1]/a', :text => I18n.translate('users.show.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should not go to the Site map page when the footer site map link is clicked (goes to signin page)' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('home.site_map.title')}$/
    end	
  end

  context ' - Layout Links (Logged in Regular User) - ' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      visit home_index_path
    end
    it 'should go to Users index page when user clicks top nav Users link' do
      visit home_index_path
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.index.title')}$/
      find('ul#header_nav_bar').find('li[1]/a', :text => I18n.translate('users.show.title')).click
      find('#header_tagline_page_title').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
    end
    it 'should go to the Site map page when the footer site map link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('home.site_map.title')}$/
    end			
  end

  context ' - Layout Links (Logged in Admin User) - ' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      visit home_index_path
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
