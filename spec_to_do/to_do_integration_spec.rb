require 'spec_helper'

describe 'Integration Tests To Do- ' do
  
  context 'dont display fields in show or edit unless @user.can_field_be_edited?()'
  
  context 'User Administration - ' do
    it 'should list all users (by application or all?)'
    it 'should limit access to each system based upon the user roles'
    it 'should have multiple systems allowed in the app_config'
  end

  context 'Miscellaneous items to do' do
    describe 'should have an I18n application helper' do
      describe 'should have I18n logging' do
        it 'should have I18n flash notify and alert handling'
        it 'should have a convenient scoping mechanism for controllers, actions and pages'
      end
    end
    it 'allow users to modify their password (and get it sent to email)'
    it 'should allow an administrator to reset their password (and get it sent to email)'
    it 'should ensure that username comes from name in email address (less @domain)'
    it 'should send user their reset password'
    it 'should have standardized yields with the layout'
    it 'should be html5 with graceful degradations'
  end

  context 'Have app_config fully tested' do
    it 'should have Application Configuration Constants (config/application.rb, config/environments/*.rb ) tested in automated tests'
  end

end
