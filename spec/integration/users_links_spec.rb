require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe "Users Links tests" do

  context 'visit Users Index page' do
    before(:each) do
      @user = User.create!(UserTestHelper.user_minimum_create_attributes)
      visit users_path
    end
    it "should have a working New user link" do
      # save_and_open_page
      # should start at the Users Index page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.index.title')}$/
      # should click on the new user link
      find('a', :text => I18n.translate('users.new.title')).click
      # should bring user to the New User page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.new.title')}$/
    end
    it "should have a working View user link" do
      # should have a user
      User.count.should > 0
      # should be on index page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
      # should click on show button
      find(:xpath, "//tr[@id=\"user_#{@user.id}\"]//a", :text => "#{I18n.translate('view_action.show')}").click
      # should bring user to the Show User page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.show.title')}$/
    end
    it "should have a working Edit user link" do
      # should have a user
      User.count.should > 0
      # should be on index page
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.index.title')}$/
      # should click on show button
      find(:xpath, "//tr[@id=\"user_#{@user.id}\"]//a", :text => "#{I18n.translate('view_action.edit')}").click
      # should bring user to the Show User page
      find('#header_tagline_page_title').text.should =~ /^#{I18n.translate('users.edit.title')}$/
    end
    # not testing delete/deactivate/reactivate here
  end

end
