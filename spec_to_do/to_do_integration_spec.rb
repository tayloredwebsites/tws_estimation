require 'spec_helper'
require 'capybara_spec_helper'

describe 'Integration Tests To Do- ' do

  context 'User Role Based Authorization' do
    it 'should have role based authorization'
    it 'should have application specified in roles'
    it 'should have multiple applications allowed in the app_config'
    it 'should allow (administrative) users to assign a user to a role'
    it 'should allow (administrative) users to assign a user to an application with a particular role'
    it 'should allow (administrative) users to assign a user to all applications with a particular'
    it 'should have applications to have their own scope'
  end

  context 'User Administration - ' do
    it 'should have an admin namespaced controller for User Maintenance'
    it 'should not allow a regular user (per application) to access the user maintenance controller (and actions)'
    it 'should not allow a regular user to assign a user to a role'
    it 'should allow users with the admin role (per application) to create a user'
    it 'should allow users with the admin role (per application) to access the user maintenance controller (and actions)'
    it 'should not allow a regular user to create a user'
    it 'should list all users (by application or all?)'
  end

  context 'Miscellaneous items to do' do
    describe 'should have an I18n application helper' do
      describe 'should have I18n logging' do
        it 'should have I18n flash notify and alert handling'
        it 'should have a convenient scoping mechanism for controllers, actions and pages'
      end
    end
    it 'should ensure that username comes from name in email address (less @domain)'
    it 'should send user their reset password'
    it 'should have standardized yields with the layout'
    it 'should be html5 with graceful degradations'
  end

  context 'Have app_config fully tested' do
    it 'should have Application Configuration Constants (config/application.rb, config/environments/*.rb ) tested in automated tests'
  end

end
