require 'spec_helper'
include UserTestHelper

include ApplicationHelper

require 'capybara_spec_helper'

describe 'Sessions Actions Tests' do

  before(:each) do
    @user1 = FactoryGirl.create(:user_min_create_attr)
    @model = User.new
  end
  
  context 'visit login path - ' do
    
    it 'should show the title and login fields of the login page - ' do
      visit signin_path
      # save_and_open_page
      # should be on login page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should show the username field
      find(:xpath, '//input[@id="user_session_username"]').should_not be_nil
      # should show the password field
      find(:xpath, '//input[@id="user_session_password"]').should_not be_nil
      # should show the login button
      find(:xpath, '//input[@id="user_session_submit"]').should_not be_nil
    end
    
  end
  
  context 'login - ' do
    
    before(:each) do
      visit signin_path
      # save_and_open_page
      # should be on login page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
    end

    context 'login with invalid credentials - ' do
      
      before(:each) do
        # should fill in the login form to login
        page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
        page.fill_in('user_session[password]', :with => 'invalidpwd' )
        # save_and_open_page
        find(:xpath, '//input[@id="user_session_submit"]').click
      end
      
      it 'should send the user to the Login page (Session New page) with invalid credentials submitted' do
        # save_and_open_page
        # should be on the Session Create page
        find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
        # it should display an error to the user
      end
      
      it 'should not welcome user, should request user to signin' do
        find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
          /^#{I18n.translate('users_sessions.signin.title') }$/
      end
    end
    
    context 'login with valid credentials - ' do
      
      before(:each) do
        # should fill in the login form to login
        page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
        page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password] )
        find(:xpath, '//input[@id="user_session_submit"]').click
      end
      
      it 'should send the user to the Logged In page (Session Create page) with valid credentials submitted' do
        # save_and_open_page
        # should be on the Session Create page
        find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      end
      
      it 'should remove the users name from the layout' do
        find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
          /#{I18n.translate('view_labels.welcome_user', :user => current_user_full_name) }/
      end
      it 'should have the user in the current session'
      it 'should have all further actions be performed by the authenticated user'
    end
    
    context 'logout - ' do
      before(:each) do
        
      end
      it 'should log the user out'
      it 'should show the user as logged out'
      it 'should have all further actions be performed by the authenticated user'
    end
    
    it 'should show the title and fields of the user home page - ' do
    end
    
  end
  
  context 'visit logout path (should duplicate session#new) - ' do
  end
  
end
