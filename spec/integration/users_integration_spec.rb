require 'spec_helper'
include UserTestHelper

# include ApplicationHelper

require 'capybara_spec_helper'

describe 'Signed in Users Integration Tests' do

  before(:each) do
    @model = User.new
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    visit signin_path
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.signin.title')}$/
    # should fill in the login form to login
    page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username] )
    page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password] )
    find(:xpath, '//input[@id="user_session_submit"]').click
    # save_and_open_page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users_sessions.create.title')}$/
    find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
      /#{I18n.translate('view_labels.welcome_user', :user => @me.full_name) }/
    visit home_index_path
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

end

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
    it 'should let non-admin users view themself .....'
    it 'should show all of the users authorized roles as checked'
    it 'should set all roles for the user when checked'
    it 'should remove all roles from the user when unchecked'    
    it 'should ensure that user assigned roles are preserved in the database'
    it 'should limit access to each system based upon the user roles'
    it 'should have multiple systems allowed in the app_config'
  end


end
