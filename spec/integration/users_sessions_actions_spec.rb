require 'spec_helper'
include UserTestHelper

include ApplicationHelper

require 'capybara_spec_helper'

describe 'Sessions Actions Tests' do

  before(:each) do
    @user1 = FactoryGirl.create(:user_full_create_attr)
    @admin = FactoryGirl.create(:admin_user_full_create_attr)
    @model = User.new
    visit signin_path
  end
  
  context 'visit signin path - ' do
    
    it 'should show the title and login fields of the login page - ' do
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      find(:xpath, '//input[@id="user_session_username"]').should_not be_nil
      find(:xpath, '//input[@id="user_session_password"]').should_not be_nil
      find(:xpath, '//input[@id="user_session_submit"]').should_not be_nil
    end
    
  end
  
  context 'login with invalid credentials - ' do
    it 'should send the user to the Login page (Session New page)' do
      # save_and_open_page
      # should be on login page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => 'invalidpwd' )
      # save_and_open_page
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # it should display an error to the user
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /^#{I18n.translate('users_sessions.signin.title') }$/
      # user should have a signin link in a left module header
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signin.action')}/
    end
  end
    
  context 'login with valid credentials - ' do
    it 'should send the user to the Logged In page (Session Create page)' do
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
        /#{I18n.translate('view_labels.welcome_user', :user => @user1.full_name) }/
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
        /#{I18n.translate('view_labels.welcome_user', :user => FactoryGirl.attributes_for(:user_full_create_attr)[:first_name]+' '+FactoryGirl.attributes_for(:user_full_create_attr)[:last_name] ) }/
      # user should have a signout link in a left module header
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signout.action')}/
    end
  end
  
  context 'logout - ' do
    it 'should log the user out' do
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      # click the signout link
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a', :text => I18n.translate('users_sessions.signout.action')).click
      # save_and_open_page  
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~ /^#{I18n.translate('users_sessions.signin.action')}$/
      # user should have a signin link in a left module header
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signin.action')}/
    end
  end
    
  context 'Roles - Signed in Admin User - User Pages - ' do
    before(:each) do
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      # save_and_open_page
      visit edit_user_path (@user1.id)
    end
    it 'should list all of the systems in VALID_ROLES (app_constant.rb) using I18n' do
      # save_and_open_page
      VALID_ROLES.each do |role|
        find(:xpath, '//form[@class="edit_user"]/div/div/label', :text => Role.new(role).sys_name ).should be_true
      end
    end
    it 'should list all of the valid roles by system using i18n' do
      # save_and_open_page
      VALID_ROLES.each do |role|
        find(:xpath, '//form[@class="edit_user"]/div/div/span/span', :text => Role.new(role).role_name ).should be_true
      end
    end
    it 'should show all of the users authorized roles as checked'
    it 'should set all roles for the user when checked'
    it 'should remove all roles from the user when unchecked'    
    it 'should ensure that user assigned roles are preserved in the database'
    it 'should limit access to each system based upon the user roles'
    it 'should have multiple systems allowed in the app_config'
  end


end
