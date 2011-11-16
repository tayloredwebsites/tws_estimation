require 'spec_helper'
include UserTestHelper

include ApplicationHelper

require 'capybara_spec_helper'

describe 'Sessions Actions Tests' do

  before(:each) do
    @user1 = FactoryGirl.create(:user_min_create_attr)
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
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
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
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
        /#{I18n.translate('view_labels.welcome_user', :user => @user1.full_name) }/
      # user should have a signout link in a left module header
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signout.action')}/
    end
  end
  
  context 'logout - ' do
    it 'should log the user out' do
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password] )
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
    

end
