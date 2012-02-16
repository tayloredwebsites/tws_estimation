require 'spec_helper'

describe 'Miscellaneous items to do - ' do
  it 'allow users to reset their password (and get it sent to email)'
  it 'should allow an administrator to reset their password (and get it sent to email)'
  it 'should ensure that username comes from name in email address (less @domain)'
  it 'should send user their reset password'
  it 'should have standardized yields with the layout'
  it 'should be html5 with graceful degradations'
  it 'should have app_config fully tested'
  it 'should have testing of deactivated module' do
    it 'should have test controller and model without deactivated modules'
    it 'should have a test controller and model with the deactivation modules included'
    it 'should have a copy of the user deactivation tests for no deactivation modules'
    it 'should have a copy of the user deactivation tests for with deactivation modules'
  end
end
