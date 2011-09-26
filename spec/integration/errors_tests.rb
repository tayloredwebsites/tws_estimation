require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe "Error Handling Display to User" do

  context 'visit Users Index page' do
    
    before(:each) do
      # @user1 = User.create!(UserTestHelper.user_minimum_attributes)
    end
    
    it "should display a :base error in the error summary/explanation section at the top of the page" do
      @testuser = User.create!(UserTestHelper.user_minimum_attributes)
      @testuser.stub(:deactivate) do |arg|
        @testuser.errors.add(:base, "any error in model stub will do")
      end
      visit deactivate_user_path (@testuser.id)
      # save_and_open_page
      # should be on edit page after unsuccessful deactivate - showing the errors
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
      # should display :base error in the view (at the top)
      find(:xpath, "//div[@id=\"error_explanation\"]//li").text.should =~ /\Aerror deactivating User\z/
    end

    it "should display a field level error in the error field section" do
      @user1 = User.create!(UserTestHelper.user_minimum_attributes)
      #confirm the user is not deactivated
      @user1.deactivated.should be_false
      # deactivate user
      @user1.deactivate
      # refresh the user from the database
      @updated_user = User.find(@user1.id)
      #confirm the user has been deactivated
      @updated_user.deactivated.should be_true
      # call the deactivate user action on a deactivated user (generating a field level error)
      visit deactivate_user_path (@user1.id)
      # save_and_open_page
      # should be on edit page after unsuccessful deactivate - showing the errors
      find(:xpath, '//*[@id="header_tagline_page_title"]').text.should =~ /^#{I18n.translate('users.edit.title')}$/
      # should display an error in the :deactivated error field
      find(:xpath, "//span[@class=\"field_error\"]").text.should =~ /\A- deactivated already\z/
    end

  end

end
