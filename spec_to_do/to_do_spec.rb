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
  it 'should give a warning to the user on problems with roles - want to update and still notify user'
  it 'should confirm that Role.sys_id and Role.sys_name correspond with app_constants.rb - APPLICATION_SYSTEMS'
  it 'should have dropdown for selection of Defaults - Value Store name, with add new Value Store name option'
  it 'should add audit trail to the defaults table for tws_auth app for audit trail example'
  it 'should let cancan authorize resources for the home controller.  Base Model? Guest Model? '
  it 'should not need the @model to be created in each controller?'
  it 'should have controllers not attempt to create records that are already there, but deactivated.'
end
