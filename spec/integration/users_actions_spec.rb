require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe 'Users Integration Tests' do

  before(:each) do
    @user1 = User.create!(UserTestHelper.user_minimum_create_attributes)
    @model = User.new
  end
  
  it 'should show the deactivated field in show' do
    visit user_path (@user1.id)
    # should be on show page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    # should show value in deactivated field
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    # should show the user as deactivated
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  end
  
  it 'should show the deactivated field in edit' do
    # go to the Edit User page
    visit edit_user_path (@user1.id)
    # save_and_open_page
    # should be on edit page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    # should show value in deactivated field
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    # should show value in deactivated field as false (default create user as not deactivated)
    find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Afalse\z/
    find(:xpath, '//*[@id="user_deactivated"]/option[@selected]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  end
  
  it 'controller should list users with deactivate/reactivate action/link/button depending upon status' do
    UserTestHelper.user_safe_attributes.each do |key, value|
      User.create!( UserTestHelper.user_minimum_create_attributes.merge({key => value}) )
    end
    @user_deact = User.create!(UserTestHelper.user_minimum_create_attributes.merge({:deactivated => true}))
    # should have a user
    User.count.should > 1
    # go to the List Users page
    visit users_path()
    # save_and_open_page
    # should be on index page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    # should show first user as not deactivated
    find(:xpath, '//tr[@id="user_1"]/td[@class="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    # should show first user with the deactivate link available
    find(:xpath, '(//tr[@id="user_1"]//a)[3]').text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
    # should show deactivated user as deactivated
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    # should show the deactivated user with the reactivate link available
    find(:xpath, "(//tr[@id=\"user_#{@user_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
    # should show the deactivated user with the delete link available
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
  end
  
  it 'Update action should allow a change from deactivated to active' do
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # get the initial users count
    @num_users = User.count
    # go to the Edit User page
    visit edit_user_path (@user1.id)
    # save_and_open_page
    # should be on edit page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    # should show value in deactivated field
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    # should show value in deactivated field as false (default create user as not deactivated)
    find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Atrue\z/
    within(".edit_user") do
      select I18n.translate('view_field_value.active'), :from => 'user_deactivated'
      find('input#user_submit').click
    end
    # save_and_open_page
    # response code should be success
    page.driver.status_code.should be 200
    # should not be errors page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('home.errors.title')}$/
    # should not be edit (error on edit)
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should_not =~ /^#{I18n.translate('users.edit.title')}$/
    # should be show page after successful edit - showing the new user
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    # should show the success message in the header and footer
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @updated_user.username )}$/
    # should have the same number of users
    User.count.should == (@num_users)
    # should show the user as deactivated
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_false
  end
  
  it 'Update action should allow a change from active to deactivated' do
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    # get the initial users count
    @num_users = User.count
    # go to the Edit User page
    visit edit_user_path (@user1.id)
    # save_and_open_page
    # should be on edit page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    # should show value in deactivated field
    find(:xpath, '//*[@id="user_deactivated"]').text.should_not =~ /\A\s*\z/
    # should show value in deactivated field as false (default create user as not deactivated)
    find(:xpath, '//*[@id="user_deactivated"]').value.should =~ /\Afalse\z/
    find(:xpath, '//*[@id="user_deactivated"]/option[@selected]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    within(".edit_user") do
      select I18n.translate('view_field_value.deactivated'), :from => 'user_deactivated'
      find('input#user_submit').click
    end
    # save_and_open_page
    # response code should be success
    page.driver.status_code.should be 200
    # should be show page after successful edit - showing the new user
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    # should show the success message in the header and footer
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => @model.class.name, :name => @user1.username )}$/
    # should have the same number of users
    User.count.should == (@num_users)
    # should show the user as deactivated
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
  end
  
  it 'should allow a user to be deactivated from the index page' do
    UserTestHelper.user_safe_attributes.each do |key, value|
      User.create!( UserTestHelper.user_minimum_create_attributes.merge({key => value}) )
    end
    @user_deact = User.create!(UserTestHelper.user_minimum_create_attributes.merge({:deactivated => true}))
    # get the initial users count
    @num_users = User.count
    # should have a user
    @num_users.should > 1
    # go to the List Users page
    visit users_path()
    # save_and_open_page
    # should be on index page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    # should show first user as not deactivated
    find(:xpath, '//tr[@id="user_1"]/td[@class="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    # # should show first user with the deactivate link available
    find(:xpath, '(//tr[@id="user_1"]//a)[3]').text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
    # should be able to click the deactivate button
    find(:xpath, '//tr[@id="user_1"]//a', :text => I18n.translate('view_action.deactivate') ).click
    # save_and_open_page
    # response code should be success
    page.driver.status_code.should be 200
    # should be show page after successful edit - showing the new user
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    # should show the success message in the header and footer
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'deactivate', :obj => @model.class.name, :name => @user1.username )}$/
    # should have the same number of users
    User.count.should == (@num_users)
    # should show the user as deactivated
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    # refresh the user from the database
    @updated_user = User.find(1)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
  end
  
  it 'should allow a user to be reactivated from the index page' do
    UserTestHelper.user_safe_attributes.each do |key, value|
      User.create!( UserTestHelper.user_minimum_create_attributes.merge({key => value}) )
    end
    @user_deact = User.create!(UserTestHelper.user_minimum_create_attributes.merge({:deactivated => true}))
    # get the initial users count
    @num_users = User.count
    # should have a user
    @num_users.should > 1
    # go to the List Users page
    visit users_path()
    # save_and_open_page
    # should be on index page
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
    # should show deactivated user as deactivated
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]/td[@class=\"user_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
    # # should show deactivated user with the reactivate link available
    find(:xpath, "(//tr[@id=\"user_#{@user_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
    # should be able to click the reactivate button
    find(:xpath, "//tr[@id=\"user_#{@user_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
    # save_and_open_page
    # response code should be success
    page.driver.status_code.should be 200
    # should be show page after successful edit - showing the new user
    find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.show.title')}$/
    # should show the success message in the header and footer
    find(:xpath, '//*[@id="header_status"]/p').text.should =~
      /^#{I18n.translate('errors.success_method_obj_name', :method => 'reactivate', :obj => @model.class.name, :name => @user1.username )}$/
    # should have the same number of users
    User.count.should == (@num_users)
    # should show the user as deactivated
    find(:xpath, '//*[@id="user_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    # refresh the user from the database
    @updated_user = User.find(1)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_false
  end

end
