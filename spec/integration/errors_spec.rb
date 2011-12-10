require 'spec_helper'
include UserTestHelper

# require 'capybara_spec_helper'

describe "Error Handling Display to User - " do

  context 'Regular User' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.index.title')}$/
    end
    
    it "should display the notify error in the error at the top of the page" do
      @testuser = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      visit user_path (@testuser.id)
      # save_and_open_page
      # should be on error page after access denied error trying to view another user when not admin - showing the errors
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /^#{I18n.translate('errors.access_denied_msg',
        :msg => 'You are not authorized to access this page.')}$/
      # page.should have_selector(:xpath, '//div[@id="content_body"]', :text => 'You are not authorized to access this page.')
    end

    it "should display Access Denied! error in the error at the top of the page" do
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => true}))
      User.count.should > 1
      visit users_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('home.errors.title')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~
        /#{I18n.translate('errors.access_denied_msg', :msg => 'You are not authorized to access this page.')}/
      # have not set up field level listings of errors
      # find(:xpath, '//div[@id="error_explanation"]//span[@class="value"]').text.should =~
      #   /\A#{I18n.translate('errors.access_denied_msg', :msg => 'You are not authorized to access this page.')}\z/
    end

    it "should display Active Record errors in the error at the top of the page" do
      visit user_path(0)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('users.index.title')}$/
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('home.errors.title')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~
        /#{I18n.translate('errors.active_record_error_msg', :msg => 'Couldn\'t find User with ID=0')}/
    end

  end
  
end
