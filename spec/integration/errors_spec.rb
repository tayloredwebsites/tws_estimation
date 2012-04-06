require 'spec_helper'
include UserIntegrationHelper

describe "Error Handling Display to User - " do

  context 'Regular User' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      helper_signin(:reg_user_full_create_attr, @me.full_name)
    end
    
    it "should display the notify error in the error at the top of the page" do
      @testuser = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      visit user_path (@testuser.id)
      # save_and_open_page
      # should be on error page after access denied error trying to view another user when not admin - showing the errors
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /^#{I18n.translate('errors.access_denied_msg_obj',
        :method => 'show', :obj => 'users')}$/
      # page.should have_selector(:xpath, '//div[@id="content_body"]', :text => 'You are not authorized to access this page.')
    end

    it "should display Access Denied! error in the error at the top of the page" do
      @user_deact = User.create!(FactoryGirl.attributes_for(:users_create).merge({:deactivated => DB_TRUE}))
      User.count.should > 1
      visit users_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~
        /#{I18n.translate('errors.access_denied_msg_obj', :method => 'index', :obj => 'users')}/
      # have not set up field level listings of errors
      # find(:xpath, '//div[@id="error_explanation"]//span[@class="value"]').text.should =~
      #   /\A#{I18n.translate('errors.access_denied_msg_obj', :method => 'show', :obj => 'users')}\z/
    end

    it "should display Active Record errors in the error at the top of the page" do
      visit user_path(0)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('users.index.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~
        /#{I18n.translate('errors.active_record_error_msg', :msg => 'Couldn\'t find User')}/
    end

  end
  
end
