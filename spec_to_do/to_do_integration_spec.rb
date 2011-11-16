require 'spec_helper'
require 'capybara_spec_helper'

describe 'Integration Tests To Do- ' do


  context 'User Administration - ' do
    it 'should allow the users to edit their own information'
    it 'should allow the admins to edit their any user\'s information' 
    it 'should not allow deactivate unless signed in as admin'
    it 'should not allow reactivate unless signed in as admin'
    it 'should not allow delete unless signed in as admin, has been deactivated, and table ok for deletes without cleanup'
    it 'should allow the users to view their own information' # see users_controller_spec.rb
    it 'should not allow users to view other users information' # to do in users_controller_spec.rb
    it 'should allow users limited access to modify or delete their own information' # to do in users_controller_spec.rb
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
