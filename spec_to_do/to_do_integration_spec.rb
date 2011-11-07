require 'spec_helper'
require 'capybara_spec_helper'

describe 'Integration Tests To Do- ' do

  context 'User Authentication' do
    it 'may need to use email validations see lesson 56, 56:00 - 1:20:00'
    context 'all users -' do
      it 'should be able to navigate to the PUT reset_password page'
    end
    context 'not logged in (guest user) -' do
    end
    context 'logged in user -' do
      it 'should be able to update password'
    end

  end
  

  context 'User Role Based Authorization' do
    it 'should have role based authorization'
    it 'should have application specified in roles'
    it 'should have multiple applications allowed in the app_config'
    it 'should have applications to have their own scope'
  end

  context 'User Administration' do
    it 'should have an admin namespaced controller for User Maintenance'
    it 'should remove the ability for any user to create a user'
    it 'should only allow users with the admin role (for all applications?) to access the user maintenance controller (and actions)'
    it 'should list all users (by application or all?)'
    it 'should allow crud access to users (by application or all?)'
    it 'should allow users to be assigned to a role'
    it 'should allow users to be assigned to an application with a particular role'
    it 'should allow users to be assigned a role to all applications'
  end

  context 'Miscellaneous items to do' do
    describe 'should have an I18n application helper' do
      describe 'should have I18n logging' do
        it 'should have I18n flash notify and alert handling'
        it 'should have a convenient scoping mechanism for controllers, actions and pages'
      end
    end
    it 'should have standardized yields with the layout'
    it 'should be html5 with graceful degradations'
  end

  context 'Have app_config fully tested' do
    it 'should have Application Configuration Constants (config/application.rb, config/environments/*.rb ) tested in automated tests'
  end

end
