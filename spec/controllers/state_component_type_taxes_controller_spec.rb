# spec/controllers/state_component_type_taxes_controller_spec.rb

# it 'should have a StateComponentTypeTax table to store the default tax rate by State and Component Type'

require 'spec_helper'
include SpecHelper
include UserTestHelper
include ApplicationHelper

describe StateComponentTypeTaxesController do

  before(:each) do
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
    @my_session.signed_in?.should be_true
    @my_session.current_user.has_role?('all_admins').should be_true
    @state = State.create!(FactoryGirl.attributes_for(:state))
    @state2 = State.create!(FactoryGirl.attributes_for(:state))
    @job_type_reg = JobType.create!(FactoryGirl.attributes_for(:job_type))
    Rails.logger.debug("T @job_type_reg : #{@job_type_reg.inspect.to_s}")
    @job_type_non_taxable = JobType.create!(FactoryGirl.attributes_for(:job_type))
    @component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    @component_type2 = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    @tax_type_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type)
    @tax_type_attribs_non_taxable = UserIntegrationHelper.build_attributes(:state_component_type_non_taxable, state: @state, job_type: @job_type_non_taxable, component_type: @component_type)
    @tax_type_change_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax_changes, state: @state2, job_type: @job_type_non_taxable, component_type: @component_type2)
    @tax_type_req_attribs = @tax_type_attribs.clone.keep_if {|k,v| SpecHelper::REQUIRED_STATE_COMPONENT_TYPE_TAX_FIELDS.include?(k.to_sym)}
    # @tax_type_reg = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type))
    @tax_type_reg = StateComponentTypeTax.create!(@tax_type_attribs)
    # @tax_type_non_taxable = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_non_taxable, state: @state, job_type: @job_type_non_taxable, component_type: @component_type))
    @tax_type_non_taxable = StateComponentTypeTax.create!(@tax_type_attribs_non_taxable)
    Rails.logger.debug("T state_component_type_taxes_integration_spec initial creations done")
  end
  context 'it should have crud actions available and working' do
    it 'should be able to GET the index page and see all items' do
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:state_component_type_taxes).count.should == 2
    end
    it 'should be able to GET new item' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).should be_instance_of(StateComponentTypeTax) 
      assigns(:state_component_type_tax).should_not be_persisted
    end
    it "should create an item with the minimum valid parameters" do
      @num_items = StateComponentTypeTax.count
      min_attr = @tax_type_req_attribs
      Rails.logger.debug("T required attributes: #{min_attr.inspect.to_s}")
      post :create, :state_component_type_tax => min_attr
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).should be_instance_of(StateComponentTypeTax) 
      assigns(:state_component_type_tax).should be_persisted
      response.should render_template("show")
      StateComponentTypeTax.count.should == @num_items + 1
    end
    it 'should be able to GET edit an item' do
      get :edit, :id => @tax_type_reg.id
      response.should be_success
      response.should render_template('/edit')
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).should be_instance_of(StateComponentTypeTax) 
      assigns(:state_component_type_tax).should eq(@tax_type_reg)
    end
    it 'should be able to PUT update an item' do
      new_attribs = @tax_type_change_attribs
      put :update, :id => @tax_type_reg.id, :state_component_type_tax => new_attribs
      updated_item = StateComponentTypeTax.find(@tax_type_reg.id)
      Rails.logger.debug("T component_controller_spec updated_item = #{updated_item.inspect.to_s}")
      updated_item.should_not be_nil
      new_attribs.each  do |key, value|
        Rails.logger.debug("T component_controller_spec udpate - for #{key.to_s} - match #{updated_item.send(key.to_sym)} to #{key.to_s} / #{value.to_s}")
        # assigns(:state_component_type_taxes).send(key.to_sym).should eq(new_attribs[key.to_sym])
        updated_item.send(key.to_sym).should eq(value)
      end
      # response.should render_template("show")
      response.should redirect_to(:controller => 'state_component_type_taxes', :action => 'show')
    end
    it 'should be able to GET show an item' do
      get :show, :id => @tax_type_reg.id
      response.should be_success
      response.should render_template('/show')
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).should be_instance_of(StateComponentTypeTax) 
      assigns(:state_component_type_tax).should eq(@tax_type_reg)
    end
    it 'should see the errors page on an ActiveRecord error' do
      get :show, :id => 0
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
  end
  
  context 'it should have deactivated actions available and working' do
    it 'should be able to PUT deactivate an active item' do
      @tax_type_reg.deactivated?.should be_false
      put :deactivate, :id => @tax_type_reg.id
      response.should be_success
      response.code.should be == '200'
      response.should render_template("show")
      updated_item = StateComponentTypeTax.find(@tax_type_reg.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      @tax_type_reg.deactivated?.should be_false
      @tax_type_reg.deactivate
      @tax_type_reg.errors.count.should be == 0
      updated_item = StateComponentTypeTax.find(@tax_type_reg.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :deactivate, :id => @tax_type_reg.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:state_component_type_tax).errors.count.should be > 0
      assigns(:state_component_type_tax).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:state_component_type_tax).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      @tax_type_reg.deactivated?.should be_false
      @tax_type_reg.deactivate
      @tax_type_reg.errors.count.should be == 0
      updated_item = StateComponentTypeTax.find(@tax_type_reg.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :reactivate, :id => @tax_type_reg.id
      response.should be_success
      response.code.should be == '200'
      assigns(:state_component_type_tax).errors.count.should be == 0
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).deactivated?.should be_false
      response.should render_template("show")
      updated_item2 = StateComponentTypeTax.find(@tax_type_reg.id)
      updated_item2.should_not be_nil
      updated_item2.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      @tax_type_reg.deactivated?.should be_false
      put :reactivate, :id => @tax_type_reg.id
      response.should be_success
      response.code.should be == '200'
      assigns(:state_component_type_tax).errors.count.should be > 0
      assigns(:state_component_type_tax).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:state_component_type_tax).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:state_component_type_tax).should_not be_nil
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      item_count = StateComponentTypeTax.count
      @tax_type_reg.deactivated?.should be_false
      delete :destroy, :id => @tax_type_reg.id
      StateComponentTypeTax.count.should == item_count
      # assigns(:state_component_type_taxes).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:state_component_type_tax).should be_a(StateComponentTypeTax)
      assigns(:state_component_type_tax).should eq(@tax_type_reg)
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      item_count = StateComponentTypeTax.count
      @tax_type_reg.deactivate
      @tax_type_reg.errors.count.should == 0
      delete :destroy, :id => @tax_type_reg.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == StateComponentTypeTax.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated items
      item_count = StateComponentTypeTax.count
      @tax_type_reg.deactivate
      @tax_type_reg.errors.count.should == 0
      delete :destroy, :id => @tax_type_reg.id
      response.should render_template('/index')
      # response.should redirect_to(:controller => 'home', :action => 'errors')
      StateComponentTypeTax.count.should == item_count - 1
    end
    it 'should be able to set and clear the show_deactivated flag (item count should be reflected)' do
      @tax_type_reg.deactivate
      @tax_type_reg.errors.count.should == 0
      item_count = StateComponentTypeTax.count
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      assigns(:state_component_type_taxes).size.should == item_count - 1
      StateComponentTypeTax.count.should == item_count
      get :index, :show_deactivated => DB_TRUE.to_s
      assigns(:state_component_type_taxes).size.should  == item_count
      StateComponentTypeTax.count.should == item_count
      get :index  # run again to confirm the show_deactivated sticks
      assigns(:state_component_type_taxes).size.should  == item_count
      StateComponentTypeTax.count.should == item_count
      get :index, :show_deactivated => DB_FALSE.to_s
      assigns(:state_component_type_taxes).size.should == item_count - 1
      StateComponentTypeTax.count.should == item_count
      get :index  # run again to confirm the show_deactivated sticks
      assigns(:state_component_type_taxes).size.should == item_count - 1
      StateComponentTypeTax.count.should == item_count
    end
  end
  
end
