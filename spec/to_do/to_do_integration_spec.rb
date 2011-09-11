require 'spec_helper'
require 'capybara_spec_helper'

describe 'Integration Tests To Do- ' do

  context 'Have solid testing environment' do
    it 'should have app_config in ruby hash (in config/locales/en.rb or config/app_config.rb depending upon display or internal)'
    it 'should have a solid test of the safe_params_init variations'
    it 'should have app_config values tested in automated tests'
    it 'should test the values of SAFE_PARAMS_FATAL values'
  end

  context 'Miscellaneous items to do' do
    it 'should have an I18n application helper' do
      it 'should have I18n logging' do
        it 'should have I18n flash notify and alert handling'
        it 'should have a convenient scoping mechanism for controllers, actions and pages'
      end
    end
    it 'should have standardized yields with the layout'
    it 'should be html5 with graceful degredations'
  end

  context 'User Authentication' do
    it 'should have user authentication'
  end
  
  context 'User Role Based Authorization' do
    it 'should have role based authorization'
    it 'should have application specified in roles'
    it 'should have multiple applications allowed in the app_config'
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

end
