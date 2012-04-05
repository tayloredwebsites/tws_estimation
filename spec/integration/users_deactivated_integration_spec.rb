# users_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Users Integration Tests' do

  context 'Admin user logged in' do
    before(:each) do
      @model = User.new
      @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      helper_signin(:admin_user_full_create_attr, @me.full_name)
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
  
    it 'should list users with deactivate/reactivate action/link/button depending upon status' do
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
        find(:xpath, '//input[@type="submit"]').click
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
        find(:xpath, '//input[@type="submit"]').click
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
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => @model.class.name, :id => @user1.id )}$/
      User.count.should == (@num_users)
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
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => @model.class.name, :id => @user_deact.id )}$/
      User.count.should == (@num_users)
      find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_false
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
    find(:xpath, '//form[@action="/users_sessions"]//input[@type="submit"]').click
  end

  it 'login with invalid credentials - should send the user to the Login page (Session New page)' do
    # should fill in the login form to login
    page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_full_create_attr)[:username] )
    page.fill_in('user_session[password]', :with => 'invalidpwd' )
    # save_and_open_page
    find(:xpath, '//form[@action="/users_sessions"]//input[@type="submit"]').click
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
      find(:xpath, '//form[@action="/users_sessions"]//input[@type="submit"]').click
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
  end
  
  context 'Admin user logged in - ' do
    before(:each) do
      # should fill in the login form to login
      helper_signin(:admin_user_full_create_attr, @admin.full_name)
      # save_and_open_page
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
end
