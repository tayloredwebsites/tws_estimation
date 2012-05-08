require 'spec_helper'

describe 'Miscellaneous items to do - ' do
  context 'resolve difference between role system and left menu systems' do
    it 'should resolve if the @systemc is needed'
    it 'should put list and index functions on the left nav'
    it 'should allow hide and show of left nav sub components'
  end
  context 'updates to tws_views generator - '
    it 'should have nil_to_s code in common model code (note need code for not deactivated models)'
    it 'should not generate deactivated tws_views code if no deactivated field _index_row, _index_head, _list, _list_head, index'
    it 'should have tws_views handle list page links and no list page links consistent to whether list is created or not'
  end
  context 'finish up estimates - ' do
    it 'should allow components to be updated on deactivated parent ? (component type select missing current id)'
    it 'should warn user or prevent editing item if parent association is deactivated'
    it 'should have estimates'
  end
  context 'password management - ' do
    it 'allow users to reset their password (and get it sent to email)'
    it 'should allow an administrator to reset their password (and get it sent to email)'
    it 'should ensure that username comes from name in email address (less @domain)'
    it 'should send user their reset password'
  end
  it 'should be html5 with graceful degradations'
  it 'should have app_config fully tested'
  context 'deactivated module' do
    it 'should have test controller and model without deactivated modules - modularized?'
    it 'should have a test controller and model with the deactivation modules included - modularized?'
    it 'should have a copy of the user deactivation tests for no deactivation modules'
    it 'should have a copy of the user deactivation tests for with deactivation modules'
  end
  context 'viewing deactivated records' do
    it 'should always hide deactivated records on new/create'
    it 'should have the hide/show deactivated records status in the layout header'
  end
  it 'should give a warning to the user on problems with roles - want to update and still notify user'
  it 'should confirm that Role.app_id and Role.sys_name correspond with app_constants.rb - APPLICATION_NAV'
  it 'should have dropdown for selection of Defaults Store field - Value Store name, with add new Value Store name option'
  it 'should add audit trail to the defaults table for tws_auth app for audit trail example'
  it 'should let cancan authorize resources for the home controller.  Base Model? Guest Model? '
  it 'should remove the @model creation in each controller - unless needed for model name specification - documented for user'
  it 'should have controllers not attempt to create records that are already there, but deactivated.'
  it 'should have cancan tests either in controller or integration specs'
  context 'tws_views generator' do
    it 'should allow default values from child fields (eg AssemblyComponents.description)'
    it 'should have an erb for choosing entries in a join table (eg Components in AssemblyComponents)'
  end
  context 'systems name usage - ' do
    it 'should rename APPLICATION_NAV to APPLICATION_GROUPS IN config/initializers/app_constants.rb'
    it 'should rename en.systems to en.groups in config/locales/en.rb'
    it 'should change title of application to Estimation of systems/assemblies/components costs'
    it 'should add system resource (is this a reserved word?)'
    it 'should have system resource be a parent association to assemblies/assembly_components'
  end
  context 'Sales Reps' do
    it 'should have defaults value for minimum markup percent'
    it 'should have defaults value for maximum markup percent'
  end
end
