require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe 'Signed in Users Integration Tests' do

  before(:each) do
    @model = User.new
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_min_create_attr))
    visit signin_path
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
    # should fill in the login form to login
    page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:user_min_create_attr)[:username] )
    page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:user_min_create_attr)[:password] )
    find(:xpath, '//input[@id="user_session_submit"]').click
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
  end
  
  it 'should GET show the active user as not deactivated' do
    visit user_path (@user1.id)
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  end
  
  it 'should show the deactivated field in edit' do
    visit edit_user_path (@user1.id)
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Afalse\z/
    find(:xpath, '//*[@id="user_deactivated"]/option[@selected]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  end
  
  it 'controller should list users with deactivate/reactivate action/link/button depending upon status' do
    # UserTestHelper.user_safe_attributes.each do |key, value|
    #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
    # end
    @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => true}))
    User.count.should > 1
    visit users_path()
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    find(:xpath, "(//tr[@id=\"user_#{@user1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    find(:xpath, "(//tr[@id=\"user_#{@user_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
  end
  
  it 'Update action should allow a change from deactivated to active' do
    @user1.deactivated.should be_false
    @user1.deactivate
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
    @num_users = User.count
    visit edit_user_path (@user1.id)
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Atrue\z/
    within(".edit_user") do
      select I18n.translate('view_field_value.active'), :from => 'user_deactivated'
      find('input#user_submit').click
    end
    # save_and_open_page
    page.driver.status_code.should be 200
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('home.errors.title')}$/
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('users.edit.title')}$/
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @updated_user.username )}$/
    User.count.should == (@num_users)
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_false
  end
  
  it 'Update action should allow a change from active to deactivated' do
    @user1.deactivated.should be_false
    @num_users = User.count
    visit edit_user_path (@user1.id)
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Afalse\z/
    find(:xpath, '//*[@id="user_deactivated"]/option[@selected]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    within(".edit_user") do
      select I18n.translate('view_field_value.deactivated'), :from => 'user_deactivated'
      find('input#user_submit').click
    end
    # save_and_open_page
    page.driver.status_code.should be 200
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
    User.count.should == (@num_users)
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
  end
  
  it "should have a working New user link on the index page" do
    # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
    #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
    # end
    @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => true}))
    @num_users = User.count
    @num_users.should > 1
    visit users_path()
    # save_and_open_page
    find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.index.title')}$/
    find('a', :text => I18n.translate('users.new.title')).click
    find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.new.title')}$/
  end
  
  it "should have a working View user link on the index page" do
    # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
    #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
    # end
    @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => true}))
    @num_users = User.count
    @num_users.should > 1
    visit users_path()
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => "#{I18n.translate('view_action.show')}").click
    find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.show.title')}$/
  end
  
  it "should have a working Edit user link on the index page" do
   # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
   #    User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
   #  end
    @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => true}))
    @num_users = User.count
    @num_users.should > 1
    visit users_path()
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => "#{I18n.translate('view_action.edit')}").click
    find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.edit.title')}$/
  end
  it 'should allow a user to be deactivated from the index page' do
    # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
    #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
    # end
    @user_deact = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge({:deactivated => true}))
    @num_users = User.count
    @num_users.should > 1
    visit users_path()
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    find(:xpath, "(//tr[@id=\"user_#{@user1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
    find(:xpath, "//tr[@id=\"user_#{@user1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
    # save_and_open_page
    page.driver.status_code.should be 200
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'deactivate', :obj => @model.class.name, :name => @user1.username )}$/
    User.count.should == (@num_users)
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
  end
  
  it 'should allow a user to be reactivated from the index page' do
    # FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
    #   User.create!( FactoryGirl.attributes_for(:user_min_create_attr).merge({key => value}) )
    # end
    @user_deact = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge({:deactivated => true}))
    @num_users = User.count
    @num_users.should > 1
    visit users_path()
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
    find(:xpath, "(//tr[@id=\"user_#{@user_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
    # click on reactivate button of deactivated user
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
    # save_and_open_page
    page.driver.status_code.should be 200
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'reactivate', :obj => @model.class.name, :name => @user_deact.username )}$/
    User.count.should == (@num_users)
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_false
  end

  context 'User Role Based Authorization' do
    it 'should ensure that logged out users have the default role'
    it 'should allow for users to be assigned roles from the VALID_ROLES app_constant'
    it 'should not allow for users to be assigned roles not in the VALID_ROLES app_constant'
    it 'should ensure that user assigned roles are preserved in the database'
    it 'should have which subsystems are specified in each role'
    it 'should allow admin users to assign a user to an subsystem role'
    it 'should limit access to each subsystem based upon the user roles'
    it 'should have multiple subsystems allowed in the app_config'
  end

end
