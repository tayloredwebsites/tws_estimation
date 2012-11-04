require 'spec_helper'

describe 'Miscellaneous items to do - ' do
  context 'important changes' do
    it 'should have no translations missing'
    it 'should have proper email validations'
    it 'should confirm that an email is correct'
    it 'should let users specify system minimum and maximum markup percent (10 max now)'
    it 'should prevent entering values outside of minimum and maximum values (general solution for all components?)'
    it 'should ensure required components are entered'
    it 'should only total $ amounts in totals'
    it 'should warn if there are unconverted hours'
    it 'should prevent the user clicking enter on an estimate without required fields (or else update everything else!, or allow go back to re-enter)'
  end
  context 'important documentation' do
    it 'should have grid calculations documented'
  end
  context 'Misc. estimates - ' do
    it 'should allow components to be updated on deactivated parent ? (component type select missing current id)'
    it 'should confirm all deactivations make sense and work and test out properly'
    it 'should add the tests for translations missing - context to integration specs for all resources'
    it 'should prevent Active Record Error! after deactivating in hide deactivated mode'
    it 'should not list component type column in totals grid if not in estimate? note by hiding, may impact calculations if added, lose reminder, different estimate job types '
    it 'should flag users that totals are wrong after some input'
    it 'should not reference @model - effects tws_auth also'
    it 'should list estimates by sales rep in proper order'
    it 'should list estimates by title in proper order'
    it 'should not have default values in unselected assemblies'
    it 'should not accumulate values in unselected assemblies'
    it 'should not show subtotals if all grid_subtotal entries are blank'
    it 'should not subtotal deactivated components'   
  end
  context 'i18n testing' do
    context 'Logged Out user systems' do
      it 'should have no translations missing'
    end
    context 'Regular user systems' do
      before(:each) do
        @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
        helper_signin(:reg_user_full_create_attr, @me.full_name)
        visit home_index_path
        Rails.logger.debug("T System Tests - Regular user systems - before each is done.")
      end
      it 'should have no translations missing'
    end
    context 'Administrator user systems' do
      before(:each) do
        @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
        helper_signin(:admin_user_full_create_attr, @me.full_name)
        visit home_index_path
      end
      it 'should have no translations missing'
    end
  end
  context 'heroku' do
    it should fix deprecation warning DEPRECATION WARNING: You have Rails 2.3-style plugins in vendor/plugins! Support for these plugins will be removed in Rails 4.0. Move them out and bundle them in your Gemfile, or fold them in to your app as lib/myplugin/* and config/initializers/myplugin.rb. See the release notes for more on this: http://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released. (called from <top (required)> at /app/Rakefile:11)/ 
  end
  context 'tws_auth cleanup' do
    it 'should add the translations missing - context to integration specs for all resources'
    it 'should not reference @model - effects tws_estimate also'
    it 'should have field errors on label and field or just on field, not a mix (see estimate entry)'
  end
  context 'resolve difference between role system and left menu systems' do
    it 'should resolve if the @systemc is needed'
    it 'should allow hide and show of left nav sub components'
  end
  context 'remove warnings' do
    it "should replace all :confirm options with :data => { :confirm => 'Text' }"
  end
  context 'updates to tws_views generator - '
    it 'should have nil_to_s code in common model code (note need code for not deactivated models)'
    it 'should not generate deactivated tws_views code if no deactivated field _index_row, _index_head, _list, _list_head, index'
    it 'should have tws_views handle list page links and no list page links consistent to whether list is created or not'
  end
  context 'password management - ' do
    it 'allow users to reset their password (and get it sent to email)'
    it 'should allow an administrator to reset their password (and get it sent to email)'
    it 'should ensure that username comes from name in email address (less @domain)'
    it 'should send user their reset password'
  end
  context 'use audit instead of deactivated module' do
    it 'should confirm that paper trail will easily provice reactivations'
    it 'should provide simple migration from deactivated to paper trail - including view generators'
    it 'should look into seeing if paper trail can provide an audit trail - listing using hash vs active object'
  end
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
  context 'user roles maintenance - ' do
    it 'should allow roles to checked if an administrator'
    it 'should allow roles to be unchecked if an administrator'
    it 'should not allow roles to checked or unchecked if not an administrator'
    it 'should give a warning to the user on problems with roles - want to update and still notify user'
    it 'should confirm that Role.app_id and Role.sys_name correspond with app_constants.rb - APPLICATION_NAV'
    it 'should let cancan authorize resources for the home controller.  Base Model? Guest Model? '
    it 'should have cancan tests either in controller or integration specs'
  end
  it 'should be html5 with graceful degradations'
  it 'should have app_config fully tested'
  it 'should have dropdown for selection of Defaults Store field - Value Store name, with add new Value Store name option'
  it 'should add audit trail to the defaults table for tws_auth app for audit trail example'
  it 'should remove the @model creation in each controller - unless needed for model name specification - documented for user'
  it 'should have controllers not attempt to create records that are already there, but deactivated.'
  context 'tws_views generator' do
    it 'should allow default values from child fields (eg AssemblyComponents.description)'
    it 'should have an erb for choosing entries in a join table (eg Components in AssemblyComponents)'
  end
  context 'systems/product/service product/good name usage - ' do
    it 'should change title of application to Estimation of systems/assemblies/components costs'
    it 'should add system resource (is this a reserved word?)'
    it 'should have system resource be a parent association to assemblies/assembly_components'
  end
  context 'Sales Reps' do
    it 'should have defaults value for minimum markup percent'
    it 'should have defaults value for maximum markup percent'
  end
end
