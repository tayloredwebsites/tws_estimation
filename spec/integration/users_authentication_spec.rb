require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe 'Users Authentication Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @model = User.new
    @user_session = UserSession.new
  end
  
  context 'should allow the users to view their own information' do
    it 'should find the content from the Users Show page' do    # capybara find
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    end
  end
  
  context 'should allow users to be created' do
    it 'should allow a post create for the user' do
      # get the initial users count
      @num_users = User.count
      # go to the New User page
      visit new_user_path
      # confirm we are at the New User page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.new.title')}$/
      # fill in the form and submit
      within("#new_user") do
        fill_in 'user_email', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:email]
        fill_in 'user_username', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username]
        fill_in 'user_password', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password]
        fill_in 'user_password_confirmation', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password_confirmation]
        find('input#user_submit').click
      end
      # # response code should be success
      # page.driver.status_code.should be 200
      # # should not be errors page
      # find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('home.errors.title')}$/
      # # should not be new (error on create)
      # find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('users.new.title')}$/
      # # should be show page after successful create - showing the new user
      # find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
      # # should have one more user
      # User.count.should == (@num_users+1)
      # # should show the information submitted with the form
      # find(:xpath, '//*[@id="user_username"]').text.should =~ /^#{FactoryGirl.attributes_for(:user_min_create_attr)[:username].to_s}$/
      # find(:xpath, '//*[@id="user_email"]').text.should =~ /^#{FactoryGirl.attributes_for(:user_min_create_attr)[:email].to_s}$/
    end
  end

  it 'cannot create a user without a password that matches the password confirmation' do
    # make sure user has a password accessor
    @user1.should respond_to(:password)
    # make sure user has a password confirmation accessor
    @user1.should respond_to(:password_confirmation)
    # make sure user has an encrypted_password accessor
    @user1.should respond_to(:encrypted_password)
    # make sure user has a password salt accessor
    @user1.should respond_to(:password_salt)
    
    # # make sure that user cannot be created with a missing password
    # lambda {User.create!(UserTestHelper.user_minimum_attributes)}.should raise_error(ActiveRecord::RecordNotSaved)
    # # make sure that user cannot be created with an empty password
    # lambda {User.create!(UserTestHelper.user_minimum_attributes).
    #   merge(UserTestHelper.user_create_empty_attributes)}.
    #   should raise_error(ActiveRecord::RecordNotSaved)
    
    # make sure that encrypted_password in database is not blank
    @user1.encrypted_password.should_not be_blank # do not allow nil, empty string or string with spaces
    
    # make sure User class has a method to validate passwords (class level)
    User.should respond_to(:valid_password?)
    # make sure authenticate returns nil on bad username / bad password
    User.valid_password?('xx', 'yy').should be_nil
    # make sure authenticate returns nil on good username / bad password
    User.valid_password?(FactoryGirl.attributes_for(:user_min_create_attr)[:username], 'yy').should be_nil
    # make sure authenticate returns username on good username / good password
    User.valid_password?(FactoryGirl.attributes_for(:user_min_create_attr)[:username],
      UserTestHelper.user_minimum_create_attributes[:password]).should == @user1
    
    
    # make sure that user cannot be created without password_confirmation matching password
    
    
  end
  
  it 'signed in user should have Welcome in a left module header'
  it 'signed in user should not have a signin link in a left module header'
  it 'signed in user should go to the Site map page when the footer site map link is clicked'
  it 'signed in user should be able to visit home_site_map page'  
  it 'should allow a user to sign in (chapter 9)'
  it 'should allow a user to sign out (chapter 9)'
  it 'should allow passwords to be initialized from the create action'
  it 'should allow passwords to be updated from the update_password method, action and view'
  it 'should not allow passwords to be updated from the update action'
  it 'should allow passwords to be updated in the update method in the model'

  it 'should ensure that email is unique (code 6/1:10 and db 6/1:15)'
  it 'should ensure that username is unique (code and db)'
  it 'should ensure that email is valid regex (see application constants)'
  it 'should ensure that username comes from email'

  it 'should prevent guests from signing in without correct username/password'
  it 'should always provide the code with the state and information of the current logged in user'

end