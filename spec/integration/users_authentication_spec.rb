require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe 'Users Authentication Tests' do

  before(:each) do
    @user1 = User.create!(UserTestHelper.user_minimum_attributes)
  end
  
  context 'should allow the users to view their own information' do
    it 'should find the content from the Users Show page' do    # capybara find
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    end
  end
  
  context 'should temporarily allow the users to be created without security' do
    it 'should allow a post create for the user' do
      # get the initial users count
      @num_users = User.count
      # go to the New User page
      visit new_user_path
      # confirm we are at the New User page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.new.title')}$/
      # fill in the form and submit
      within("#new_user") do
        fill_in 'user_email', :with => UserTestHelper.user_minimum_attributes[:email].to_s
        fill_in 'user_username', :with => UserTestHelper.user_minimum_attributes[:username].to_s
        find('input#user_submit').click
      end
      # response code should be success
      page.driver.status_code.should be 200
      # should not be errors page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('home.errors.title')}$/
      # should not be new (error on create)
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('users.new.title')}$/
      # should be show page after successful create - showing the new user
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
      # should have one more user
      User.count.should == (@num_users+1)
      # should show the information submitted with the form
      find(:xpath, '//*[@id="user_username"]').text.should =~ /^#{UserTestHelper.user_minimum_attributes[:username].to_s}$/
      find(:xpath, '//*[@id="user_email"]').text.should =~ /^#{UserTestHelper.user_minimum_attributes[:email].to_s}$/
    end
  end

  # it 'should allow users to log in'
  # it 'should prevent guests from signing in without correct username/password'
  # it 'should always provide the code with the state and information of the current logged in user'
  # it 'should allow for users to be assigned roles'
  # it 'should limit access to the application based upon the user roles'
  # it 'should allow for the specification of the application for a particular role'
  # 
  # it 'should allow the users to edit their own information'
  # it 'should allow the admins to edit their any user\'s information' 
  # it 'should not allow deactivate unless signed in as admin'
  # it 'should not allow reactivate unless signed in as admin'
  # it 'should not allow delete unless signed in as admin, has been deactivated, and table ok for deletes without cleanup'
  # 
  # it 'should ensure that email is unique (code 6/1:10 and db 6/1:15)'
  # it 'should ensure that username is unique (code and db)'
  # it 'should ensure that email is valid regex (see application constants)'
  # it 'should ensure that username comes from email'

end