# spec/controllers/assembly_components_controller_spec.rb

require 'spec_helper'
include UserTestHelper
include ApplicationHelper

describe AssemblyComponentsController do

  context 'it should have crud actions available and working' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
      @parent = FactoryGirl.create(:assembly_create)
      @component_type = FactoryGirl.create(:component_type)
      @child = FactoryGirl.create(:component_min_create, :component_type => @component_type)
      @child2 = FactoryGirl.create(:component_min_create, :component_type => @component_type)
      @child3 = FactoryGirl.create(:component_min_create, :component_type => @component_type)
    end
    it 'should be able to GET the index page and see all items' do
      # user = FactoryGirl.create(:user_min_create_attr)
      item1 = FactoryGirl.create(:assembly_component_create, :assembly => @parent, :component => @child)
      item2 = FactoryGirl.create(:assembly_component_create, :assembly => @parent, :component => @child2)
      item3 = FactoryGirl.create(:assembly_component_create, :assembly => @parent, :component => @child3)
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:assembly_components).count.should == 3
    end
    it 'should be able to GET new item' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:assembly_component).should be_instance_of(AssemblyComponent) 
    end
    it "should not create an item with the minimum valid parameters" do
      @num_items = AssemblyComponent.count
      min_attr = FactoryGirl.attributes_for(:assembly_component_min_create)
      post :create, :assembly_component => min_attr
      assigns(:assembly_component).should_not be_nil
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).should be_instance_of(AssemblyComponent) 
      assigns(:assembly_component).should_not be_persisted
      # min_attr.each  do |key, value|
      #   Rails.logger.debug("T component_types_controller_spec minimum - match on:#{key.to_s}")
      #   assigns(:assembly_component).send(key.to_sym).should eq(min_attr[key.to_sym])
      # end
      response.should render_template("new")
      response.code.should be == '200'
      # response.should be_redirect
      # response.should redirect_to('/home/errors')
      AssemblyComponent.count.should == @num_items
    end
    it 'should be able to GET edit an item' do
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      get :edit, :id => item1.id
      response.should be_success
      response.should render_template('/edit')
      assigns(:assembly_component).should_not be_nil
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).should be_instance_of(AssemblyComponent) 
      assigns(:assembly_component).should eq(item1)
    end
    it 'should be able to PUT update an item' do
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      new_attribs = FactoryGirl.attributes_for(:assembly_component_accessible)
      put :update, :id => item1.id, :assembly_component => new_attribs
      # assigns(:assembly_component).should_not be_nil
      # assigns(:assembly_component).should be_a(AssemblyComponent)
      # assigns(:assembly_component).should be_persisted
      updated_item = AssemblyComponent.find(item1.id)
      updated_item.should_not be_nil
      new_attribs.each  do |key, value|
        Rails.logger.debug("T component_controller_spec udpate - match on:#{key.to_s}")
        # assigns(:assembly_component).send(key.to_sym).should eq(new_attribs[key.to_sym])
        updated_item.send(key.to_sym).should eq(new_attribs[key.to_sym])
      end
      # response.should render_template("show")
      response.should redirect_to(:controller => 'assembly_components', :action => 'show')
    end
    it 'should be able to GET show an item' do
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      get :show, :id => item1.id
      response.should be_success
      response.should render_template('/show')
      assigns(:assembly_component).should_not be_nil
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).should be_instance_of(AssemblyComponent) 
      assigns(:assembly_component).should eq(item1)
    end
    it 'should see the errors page on an ActiveRecord error' do
      get :show, :id => 0
      response.should redirect_to(:controller => 'home', :action => 'errors')
    end
  end
  
  context 'it should have deactivated actions available and working' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
      @parent = FactoryGirl.create(:assembly_create)
      @component_type = FactoryGirl.create(:component_type)
      @child = FactoryGirl.create(:component_min_create, :component_type => @component_type)
      @child2 = FactoryGirl.create(:component_min_create, :component_type => @component_type)
    end
    
    it 'should be able to PUT deactivate an active item' do
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item1.deactivated?.should be_false
      put :deactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      response.should render_template("show")
      updated_item = AssemblyComponent.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = AssemblyComponent.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :deactivate, :id => item1.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:assembly_component).errors.count.should be > 0
      assigns(:assembly_component).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:assembly_component).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:assembly_component).should_not be_nil
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = AssemblyComponent.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:assembly_component).errors.count.should be == 0
      assigns(:assembly_component).should_not be_nil
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).deactivated?.should be_false
      response.should render_template("show")
      updated_item2 = AssemblyComponent.find(item1.id)
      updated_item2.should_not be_nil
      updated_item2.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item1.deactivated?.should be_false
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:assembly_component).errors.count.should be > 0
      assigns(:assembly_component).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:assembly_component).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:assembly_component).should_not be_nil
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      item_count = AssemblyComponent.count
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      AssemblyComponent.count.should == item_count + 1
      item1.deactivated?.should be_false
      delete :destroy, :id => item1.id
      AssemblyComponent.count.should == item_count + 1
      # assigns(:assembly_component).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:assembly_component).should be_a(AssemblyComponent)
      assigns(:assembly_component).should eq(item1)
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item_count = AssemblyComponent.count
      AssemblyComponent.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == AssemblyComponent.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated items
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item_count = AssemblyComponent.count
      AssemblyComponent.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      response.should render_template('/index')
      # response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == AssemblyComponent.count+1
    end
    it 'should be able to set and clear the show_deactivated flag (item count should be reflected)' do
      item1 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child)
      item1.errors.count.should == 0
      item2 = FactoryGirl.create(:assembly_component_min_create, :assembly => @parent, :component => @child2)
      item2.errors.count.should == 0
      item1.deactivate
      item1.errors.count.should == 0
      AssemblyComponent.count.should == 2
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      # get :index  # confirm that default startup is to not show deactivated
      response.should be_success
      response.should render_template('/index')
      assigns(:assembly_components).size.should == 1
      AssemblyComponent.count.should == 2
      get :index, :show_deactivated => DB_TRUE.to_s
      response.should be_success
      response.should render_template('/index')
      AssemblyComponent.count.should == 2
      assigns(:assembly_components).size.should  == 2
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      AssemblyComponent.count.should == 2
      assigns(:assembly_components).size.should  == 2
      get :index, :show_deactivated => DB_FALSE.to_s
      response.should be_success
      response.should render_template('/index')
      AssemblyComponent.count.should == 2
      assigns(:assembly_components).size.should  == 1
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      AssemblyComponent.count.should == 2
      assigns(:assembly_components).size.should  == 1
    end
  end
  
end
