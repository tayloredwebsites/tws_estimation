require 'spec_helper'

describe 'Multiple assemblies with same assembly_id in an estimate (awaiting quote)' do
  it 'should have an add assembly button in the estimate assemblies section'
  it 'should have a remove assembly button in the estimate assemblies section'
  it 'should allow duplicate assemblies in an estimate, and allow the user to name it'
  it 'should have estimate components reference an estimate assembly, to ensure updates to estimate component go to correct estimate assembly'
  it 'should make sure that updates to an estimate assembly component does not update the duplicate'
  it 'should make sure that updates to an estimate assembly component updates itself'
end

describe "Taxability flag by Job Type and Component Type" do
  it 'should have a new taxability table (foreign key pointers to job type and component type)'
  it 'should allow the user to specify which component types are taxable for each job type (yes or no flag)'
  it 'should specify the tax rate for a component by the taxable table flag and the state tax rate'
  it 'should allow the user to override the state tax rate by the value in the taxability table'
  it 'should allow the user to override the tax rate for each estimate component (on same line in estimate as amount and note)'
  it 'should accumulate tax totals at component type, assemby and grand totals'
end

describe 'Miscellaneous items to do - ' do
  context 'important changes' do
    it 'should have a one line text box next to (or below) estimate components for notes'
    it 'should list the component type in the AssemblyComponent entry form component listing (since components are assigned to component types)'
    it "should indicate 'component name already exists' in addition to 'component xxx has already been taken' when adding a component"
    it "should indicate 'estimate component already exists with that assembly and component', in addition to 'component xxx has already been taken' when adding an estimate component"
    it 'should not have user lose extimate numbers on new estimate errors (validate before save, or save estimate with warnings)'
    it 'should warn the user if hours have not been converted to dollars (at the end of the estimate)'
    it 'should not accumulate hours into the dollar totals column - add an hours totals column?'
    it 'should ensure that required components have amounts entered and give a warning on that line'
    it 'should separate required components from unrequired components (second column?, listed below required?)'
    it 'should let users specify system minimum and maximum markup percent (10 max now)'
    it 'should only total $ amounts in totals'
    it 'should warn if there are unconverted hours'
  end
  context 'important documentation' do
    it 'should have grid calculations documented'
  end
  context 'Misc. estimates - ' do
    it 'should prevent entering values outside of minimum and maximum values (general solution for markup % checks)'
    it 'should have no translations missing'
    it 'should have proper email validations'
    it 'should confirm that an email is correct'
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
