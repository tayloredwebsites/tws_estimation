# users_integration_spec.rb

require 'spec_helper'
include UserTestHelper
include ApplicationHelper

describe 'Users Integration Tests' do

  context 'Admin user logged in' do
    before(:each) do
      @model = User.new
      @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
        /#{I18n.translate('view_labels.welcome_user', :user => @me.full_name) }/
      visit home_index_path
      Rails.logger.debug("T users_integration_spec Admin user logged in before - done")
    end
  
    it 'should GET show the active user as not deactivated' do
      visit user_path (@user1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
  
    it 'should show the deactivated field in edit' do
      visit edit_user_path (@user1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Afalse\z/
      find(:xpath, '//*[@id="user_deactivated"]/option[@selected]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
  
    it 'controller should list users with deactivate/reactivate action/link/button depending upon status' do
      # UserTestHelper.user_safe_attributes.each do |key, value|
      #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
      # end
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => DB_TRUE.to_s}))
      User.count.should > 1
      visit users_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      #save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"user_#{@user1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"user_#{@user_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    
    it 'Update action should allow a change from deactivated to active' do
      @user1.deactivated?.should be_false
      @user1.deactivate
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      @num_users = User.count
      visit ("/users/#{@user1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Atrue\z/
      within(".edit_user") do
        select I18n.translate('view_field_value.active'), :from => 'user_deactivated'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @updated_user.username )}$/
      User.count.should == (@num_users)
      find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_false
    end
  
    it 'Update action should allow a change from active to deactivated' do
      @user1.deactivated?.should be_false
      @num_users = User.count
      visit edit_user_path (@user1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Afalse\z/
      find(:xpath, '//*[@id="user_deactivated"]/option[@selected]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      within(".edit_user") do
        select I18n.translate('view_field_value.deactivated'), :from => 'user_deactivated'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      User.count.should == (@num_users)
      find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
    end
  
    it "should have a working New user link on the index page" do
      # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
      #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
      # end
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => DB_TRUE}))
      @num_users = User.count
      @num_users.should > 1
      visit users_path()
      # save_and_open_page
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find('a', :text => I18n.translate('users.new.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('users.new.header')}$/
    end
  
    it "should have a working View user link on the index page" do
      # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
      #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
      # end
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => DB_TRUE}))
      @num_users = User.count
      @num_users.should > 1
      visit users_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => "#{I18n.translate('view_action.show')}").click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('users.show.header')}$/
    end
  
    it "should have a working Edit user link on the index page" do
     # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
     #    User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
     #  end
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => DB_TRUE}))
      @num_users = User.count
      @num_users.should > 1
      visit users_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => "#{I18n.translate('view_action.edit')}").click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('users.edit.header')}$/
    end
    
    it 'should allow a user to be deactivated from the index page' do
      # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
      #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
      # end
      @user_deact = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge({:deactivated => DB_TRUE}))
      @num_users = User.count
      @num_users.should > 1
      visit users_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"user_#{@user1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'deactivate', :obj => @model.class.name, :name => @user1.username )}$/
      User.count.should == (@num_users)
      find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
    end
  
    it 'should allow a user to be reactivated from the index page' do
      # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
      #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
      # end
      @user_deact = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge({:deactivated => DB_TRUE}))
      @num_users = User.count
      @num_users.should > 1
      visit users_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"user_#{@user_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated user
      find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'reactivate', :obj => @model.class.name, :name => @user_deact.username )}$/
      User.count.should == (@num_users)
      find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_false
    end
    
    it 'should be able to create a user with no errors displayed' do
      @num_users = User.count
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      within(".new_user") do
        page.fill_in 'user_username', :with => 'me'
        page.fill_in 'user_email', :with => 'my.email@example.com'
        page.fill_in 'user_first_name', :with => 'first'
        page.fill_in 'user_last_name', :with => 'last'
        page.fill_in 'user_password', :with => 'password'
        page.fill_in 'user_password_confirmation', :with => 'password'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      page.should_not have_selector(:xpath, '//span[@class="field_with_errors"]/input[@value="bad_email"]')
      find(:xpath, '//*[@id="header_status"]/p').text.should_not =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      @num_users.should == User.count - 1
    end
    it 'should notify user when trying to create a user with an invalid email address' do
      @num_users = User.count
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      within(".new_user") do
        page.fill_in 'user_username', :with => 'me'
        page.fill_in 'user_email', :with => 'bad_email'
        page.fill_in 'user_first_name', :with => 'first'
        page.fill_in 'user_last_name', :with => 'last'
        page.fill_in 'user_password', :with => 'password'
        page.fill_in 'user_password_confirmation', :with => 'password'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      page.should have_selector(:xpath, '//span[@class="field_with_errors"]/input[@value="bad_email"]')
      find(:xpath, '//*[@id="header_status"]/p').text.should_not =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      @num_users.should == User.count
    end
    it 'should notify user when trying to create a user without a username' do
      @num_users = User.count
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      within(".new_user") do
        page.fill_in 'user_username', :with => ''
        page.fill_in 'user_email', :with => 'bad_email'
        page.fill_in 'user_first_name', :with => 'first'
        page.fill_in 'user_last_name', :with => 'last'
        page.fill_in 'user_password', :with => 'password'
        page.fill_in 'user_password_confirmation', :with => 'password'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      page.should have_selector(:xpath, '//span[@class="field_with_errors"]/input[@id="user_username"]')
      find(:xpath, '//*[@id="header_status"]/p').text.should_not =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      @num_users.should == User.count
    end
    it 'should notify user when trying to create a user without a password' do
      @num_users = User.count
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      within(".new_user") do
        page.fill_in 'user_username', :with => 'me'
        page.fill_in 'user_email', :with => 'bad_email'
        page.fill_in 'user_first_name', :with => 'first'
        page.fill_in 'user_last_name', :with => 'last'
        page.fill_in 'user_password', :with => ''
        page.fill_in 'user_password_confirmation', :with => ''
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      page.should have_selector(:xpath, '//span[@class="field_with_errors"]/input[@id="user_password"]')
      find(:xpath, '//*[@id="header_status"]/p').text.should_not =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      @num_users.should == User.count
    end
    it 'should notify user when trying to create a user with mismatched passwords' do
      @num_users = User.count
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      within(".new_user") do
        page.fill_in 'user_username', :with => 'me'
        page.fill_in 'user_email', :with => 'bad_email'
        page.fill_in 'user_first_name', :with => 'first'
        page.fill_in 'user_last_name', :with => 'last'
        page.fill_in 'user_password', :with => 'xxx'
        page.fill_in 'user_password_confirmation', :with => 'yyy'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      page.should have_selector(:xpath, '//span[@class="field_with_errors"]/input[@id="user_password_confirmation"]')
      find(:xpath, '//*[@id="header_status"]/p').text.should_not =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      @num_users.should == User.count
    end

    it 'should not list deactivated users by default' do
      # UserTestHelper.user_safe_attributes.each do |key, value|
      #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
      # end
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => DB_TRUE}))
      User.count.should > 1
      visit users_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      # find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"user_#{@user1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end
    
    it 'should not allow a user to deactivate themselves (no deactivate button in index listing)' do
      @me.deactivated?.should be_false
      visit users_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, "//tr[@id=\"user_#{@me.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"user_#{@me.id}\"]//a[@text=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not allow a user to deactivate themselves (no deactivated select box in edit user)' do
      @me.deactivated?.should be_false
      visit edit_user_path(@me.id, :show_deactivated => DB_TRUE.to_s)
      # visit ("/users/#{@user1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      page.should_not have_selector(:xpath, '//*[@id="user_deactivated"]')
    end
  end

end

describe 'Users Sessions Integration Tests' do

  before(:each) do
    @user1 = FactoryGirl.create(:user_full_create_attr)
    @admin = FactoryGirl.create(:admin_user_full_create_attr)
    @reg = FactoryGirl.create(:reg_user_full_create_attr)
    @model = User.new
    visit signin_path
  end
  
  it 'should show the title and login fields of the login page - ' do
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    find(:xpath, '//input[@id="user_session_username"]').should_not be_nil
    find(:xpath, '//input[@id="user_session_password"]').should_not be_nil
    find(:xpath, '//input[@id="user_session_submit"]').should_not be_nil
  end

  it 'login with invalid credentials - should send the user to the Login page (Session New page)' do
    # should fill in the login form to login
    page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_full_create_attr)[:username] )
    page.fill_in('user_session[password]', :with => 'invalidpwd' )
    # save_and_open_page
    find(:xpath, '//input[@id="user_session_submit"]').click
    # save_and_open_page
    # should be on the Session Create page
    find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    # it should display an error to the user
    find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
      /^#{I18n.translate('users_sessions.signin.title') }$/
    # user should have a signin link in a left module header
    find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
      /#{I18n.translate('users_sessions.signin.action')}/
  end

  context 'Admin user logged in - visit signin path - ' do

    before(:each) do
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      Rails.logger.debug("T users_integration_spec Admin user logged in before - done")
    end
    
    it 'login with valid credentials - should send the user to the Logged In page (Session Create page)' do
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
        /#{I18n.translate('view_labels.welcome_user', :user => @admin.full_name) }/
        find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
          /#{I18n.translate('view_labels.welcome_user', :user => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:first_name]+' '+FactoryGirl.attributes_for(:admin_user_full_create_attr)[:last_name] ) }/
      # user should have a signout link in a left module header
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signout.action')}/
    end

    it 'logout - should log the user out' do
      #save_and_open_page
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
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

describe 'Users Roles Tests - ' do
    
  before(:each) do
    @user1 = FactoryGirl.create(:user_full_create_attr)
    @admin = FactoryGirl.create(:admin_user_full_create_attr)
    @reg = FactoryGirl.create(:reg_user_full_create_attr)
    @model = User.new
    visit signin_path
  end
  
  context 'Admin user logged in - ' do
    before(:each) do
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
      # save_and_open_page
    end
    it 'should see the Show User page for self' do
      visit user_path (@admin.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
    end
    it 'should see the Show User page for other' do
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
    end
    it 'should see the Edit User page for self' do
      visit edit_user_path (@admin.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
    end
    it 'should see the Edit User page for other' do
      visit edit_user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
    end
    it 'should see the List User page (index)' do
      visit users_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.index.header')}$/
    end
    it 'should see the New User page (create)' do
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.new.header')}$/
    end
    it 'should see the Edit User link in the Show User page for self' do
      visit user_path (@admin.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.edit.action'))
    end
    it 'should see the Edit User link in the Show User page for others' do
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.edit.action'))
    end
    it 'should see the Show User link in the Edit User page for self' do
      visit edit_user_path (@admin.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.show.action'))
    end
    it 'should see the Show User link in the Edit User page for others' do
      visit edit_user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.show.action'))
    end
    it 'should see the List Users link in the Show User page for self' do
      visit user_path (@admin.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.index.action'))
    end
    it 'should see the List Users link in the Show User page for others' do
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.index.action'))
    end
    it 'should see the New User link in the Show User page for self' do
      visit user_path (@admin.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.new.action'))
    end
    it 'should see the New User link in the Show User page for others' do
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.new.action'))
    end
    it 'should list all of the systems in VALID_ROLES (app_constant.rb) using I18n' do
      visit edit_user_path (@user1.id)
      # save_and_open_page
      VALID_ROLES.each do |role|
        page.should have_selector(:xpath, '//form[@class="edit_user"]/div/div/label', :text => Role.new(role).sys_name )
      end
    end
    it 'should list all of the valid roles by system using i18n' do
      visit edit_user_path (@user1.id)
      # save_and_open_page
      VALID_ROLES.each do |role|
        page.should have_selector(:xpath, '//form[@class="edit_user"]/div/div/span/label', :text => Role.new(role).role_name )
      end
    end
    it 'should show all of the users authorized roles as checked, switch checked status, confirm db update' do
      # visit ("/users/#{@user1.id}/edit?show_deactivated=true")
      visit edit_user_path (@user1.id)
      # save_and_open_page  # starting roles (default roles checked)
      work_roles = @user1.roles.clone
      Rails.logger.debug("T users_integration_spec - user roles = #{work_roles}")
      # save_and_open_page
      # switch status of roles checkbox status (note starting out with only default roles checked)
      VALID_ROLES.each do |role|
        if work_roles.split(' ').index(role).nil?
          Rails.logger.debug("T users_integration_spec - role #{role} not in user roles")
          Rails.logger.error("T-Error users_integration_spec - Error - roles not matching default") if !DEFAULT_ROLE.index('role').nil?
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should_not == 'checked'
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should be_nil
          check("user_roles_#{role}")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should == 'checked'
        else
          Rails.logger.debug("T users_integration_spec - role #{role} found in user roles")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should == 'checked'
          uncheck("user_roles_#{role}")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should_not == 'checked'
        end
      end
      find(:xpath, '//input[@id="user_submit"]').click
      @updated_user = User.find(@user1.id)
      work_roles = @updated_user.roles.clone
      Rails.logger.debug("T users_integration_spec - user roles = #{work_roles}")
      visit edit_user_path (@updated_user.id)
      # save_and_open_page  # after roles unchecked (default roles checked)
      # confirm that all roles are checked (default roles will be be automatically set again) then uncheck them
      VALID_ROLES.each do |role|
        if work_roles.split(' ').index(role).nil?
          Rails.logger.debug("T users_integration_spec - role #{role} not in user roles")
          Rails.logger.error("T-Error users_integration_spec - Error - roles not matching default") if !DEFAULT_ROLE.index('role').nil?
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should_not == 'checked'
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should be_nil
          check("user_roles_#{role}")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should == 'checked'
        else
          Rails.logger.debug("T users_integration_spec - role #{role} found in user roles")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should == 'checked'
          uncheck("user_roles_#{role}")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should_not == 'checked'
        end
      end
      find(:xpath, '//input[@id="user_submit"]').click  # update unchecking
      @updated_user = User.find(@user1.id)
      work_roles = @updated_user.roles.clone
      Rails.logger.debug("T users_integration_spec - user roles = #{work_roles}")
      visit edit_user_path (@updated_user.id)
      # save_and_open_page  # after roles reset (default roles checked)
      # confirm that all roles are unchecked (default roles will be be automatically set again)
      VALID_ROLES.each do |role|
        if work_roles.split(' ').index(role).nil?
          Rails.logger.debug("T users_integration_spec - role #{role} not in user roles")
          Rails.logger.error("T-Error users_integration_spec - Error - roles not matching default") if !DEFAULT_ROLE.index('role').nil?
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should_not == 'checked'
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should be_nil
        else
          Rails.logger.debug("T users_integration_spec - role #{role} found in user roles")
          find(:xpath, "//form[@class=\"edit_user\"]/div/div/span/span/input[@value=\"#{role}\"]" ).checked?.should == 'checked'
        end
      end
    end
    it 'should see user roles as editable checkboxes for self' do
      visit edit_user_path (@reg.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      VALID_ROLES.each do |role|
        page.should have_selector(:xpath, '//form[@class="edit_user"]/div/div/label', :text => Role.new(role).sys_name )
      end
      VALID_ROLES.each do |role|
        page.should have_selector(:xpath, '//form[@class="edit_user"]/div/div/span/label', :text => Role.new(role).role_name )
      end
    end
    it 'should not see deactivated select box for self' do
      visit edit_user_path (@admin.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      # user_deactivated
      page.should_not have_selector(:xpath, '//form[@class="edit_user"]//select[@id="user_deactivated"]')
    end
    it 'should see deactivated select box for others' do
      visit edit_user_path (@reg.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      # user_deactivated
      page.should have_selector(:xpath, '//form[@class="edit_user"]//select[@id="user_deactivated"]')
    end
  end
  context 'Regular user logged in - ' do
    before(:each) do
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # should be on the Session Create page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
      # save_and_open_page
    end
    it 'should see the Show User page for self' do
      visit user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
    end
    it 'should not see the Show User page for other' do
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should see the Edit User page for self' do
      visit edit_user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
    end
    it 'should not see the Edit User page for other' do
      visit edit_user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should not see the List User page (index) - sees home errors page' do
      visit users_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should not see the New User page (create) - sees home errors page' do
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should see the Edit User link in the Show User page for self' do
      visit user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.edit.action'))
    end
    it 'should not see the List Users link in the Show User page for self' do
      visit user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.index.action'))
    end
    it 'should not see the New User link in the Show User page for self' do
      visit user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.new.action'))
    end
    it 'should not see the List Users link in the Edit User page for self' do
      visit edit_user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.index.action'))
    end
    it 'should not see the New User link in the Edit User page for self' do
      visit edit_user_path (@reg.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="content_body"]//a', :text => I18n.translate('users.new.action'))
    end
    it 'should not see user roles as editable checkboxes for self' do
      visit edit_user_path (@reg.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      VALID_ROLES.each do |role|
        page.should_not have_selector(:xpath, '//form[@class="edit_user"]/div/div/label', :text => Role.new(role).sys_name )
      end
      VALID_ROLES.each do |role|
        page.should_not have_selector(:xpath, '//form[@class="edit_user"]/div/div/span/label', :text => Role.new(role).role_name )
      end
    end
    it 'should not see deactivated select box for self' do
      visit edit_user_path (@reg.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      # user_deactivated
      page.should_not have_selector(:xpath, '//form[@class="edit_user"]//select[@id="user_deactivated"]')
    end
    it 'should have invalid update show errors at top of page and on invalid field' do
      visit edit_user_path (@reg.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      within(".edit_user") do
        page.fill_in 'user_email', :with => 'bad_email'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      page.should have_selector(:xpath, '//span[@class="field_with_errors"]/input[@value="bad_email"]')
      find(:xpath, '//*[@id="header_status"]/p').text.should_not =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
      @updated_user = User.find(@reg.id)
      @updated_user.email.should_not =~ /bad_email/
    end
    it 'should have valid update show no errors' do
      visit edit_user_path (@reg.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.edit.header')}$/
      within(".edit_user") do
        page.fill_in 'user_email', :with => 'valid.email@example.com'
        find('input#user_submit').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      page.should_not have_selector(:xpath, '//span[@class="field_with_errors"]/input[@value="valid.email@example.com"]')
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @reg.username )}$/
      @updated_user = User.find(@reg.id)
      @updated_user.email.should =~ /valid.email@example.com/
    end
  end

  context 'Logged out user - ' do
    before(:each) do
    end
    it 'should not see the Show User page' do
      visit user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    end
    it 'should not see the Edit User page' do
      visit edit_user_path (@user1.id)
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    end
    it 'should not see the List User page (index) - sees home errors page' do
      visit users_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    end
    it 'should not see the New User page (create) - sees home errors page' do
      visit new_user_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    end
  end

end

describe 'Systems Tests' do

  context 'Logged Out user systems' do
    it 'should have home system for home page' do
      visit home_index_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
    end
    it 'should have home system for errors page' do
      visit home_errors_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should see limited maint menu items' do
    #  visit reset_password_path
    #  find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      visit signin_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    end
    it 'should not see estim menu items (does not have estim_user role)' do
      visit home_index_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="left_content"]//li', :text => I18n.translate('systems.estim.full_path'))
    end
  end
  context 'Regular user systems' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:reg_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
      visit home_index_path
      Rails.logger.debug("T System Tests - Regular user systems - before each is done.")
    end
    it 'should have home system for home page' do
      visit home_index_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
    end
    it 'should have home system for errors page' do
      visit home_errors_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should have maint system for user pages' do
      visit user_path(@me.id)
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.maint.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
    end
    it 'should see maint menu item (has maint_user role)' do
      visit home_index_path
      # save_and_open_page
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
      page.should have_selector(:xpath, '//div[@id="left_content"]//li', :text => I18n.translate('users.show.title'))
      page.should have_selector(:xpath, '//div[@id="left_content"]//li', :text => I18n.translate('systems.maint.full_name'))
    end
    it 'should see estim menu item (has estim_user role)' do
      visit home_index_path
      # save_and_open_page
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
      page.should have_selector(:xpath, '//div[@id="left_content"]//li', :text => I18n.translate('systems.estim.full_name'))
    end
    # it 'should see the maintenance menu sub items if currently in that system'
    # it 'should see the estimation menu sub items if currently in that system'
  end
  context 'Administrator user systems' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      visit signin_path
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
      # should fill in the login form to login
      page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
      page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
      find(:xpath, '//input[@id="user_session_submit"]').click
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.index.header')}$/
      visit home_index_path
    end
    it 'should have home system for home page' do
      visit home_index_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
    end
    it 'should have home system for errors page' do
      visit home_errors_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should have maint system for user pages' do
      visit user_path(@me.id)
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.maint.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
    end
    it 'should see maint menu admin items' do
      visit home_index_path
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('systems.guest.full_name')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.index.header')}$/
      page.should have_selector(:xpath, '//div[@id="left_content"]//li', :text => I18n.translate('users.index.title'))
    end
  end
end