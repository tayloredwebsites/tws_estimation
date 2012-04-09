# spec/controllers/assemblies_controller_spec.rb

require 'spec_helper'
include UserTestHelper
include ApplicationHelper

describe AssembliesController do

  context 'it should have crud actions available and working' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
      Rails.logger.debug("T assemblies_controller_spec crud working - before done")
    end
    it 'should be able to GET the index page and see all items' do
      # user = FactoryGirl.create(:user_min_create_attr)
      item1 = FactoryGirl.create(:assembly_min_create)
      item2 = FactoryGirl.create(:assembly_min_create)
      item3 = FactoryGirl.create(:assembly_min_create)
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:assemblies).count.should == 3
    end
    it 'should be able to GET new item' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:assembly).should be_instance_of(Assembly) 
    end
    it "should create an item using POST" do
      @num_items = Assembly.count
      new_attributes = FactoryGirl.attributes_for(:assembly_accessible_create)
      post :create, :assembly => new_attributes
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_instance_of(Assembly) 
      assigns(:assembly).should be_persisted
      new_attributes.each  do |key, value|
        Rails.logger.debug("T assemblies_controller_spec minimum - match on:#{key.to_s}")
        assigns(:assembly).send(key.to_sym).should eq(new_attributes[key.to_sym])
      end
      response.should render_template("show")
      Assembly.count.should == (@num_items+1)
    end
    it "should create an item with the minimum valid parameters" do
      @num_items = Assembly.count
      min_attr = FactoryGirl.attributes_for(:assembly_min_create)
      post :create, :assembly => min_attr
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_instance_of(Assembly) 
      assigns(:assembly).should be_persisted
      min_attr.each  do |key, value|
        Rails.logger.debug("T assemblies_controller_spec minimum - match on:#{key.to_s}")
        assigns(:assembly).send(key.to_sym).should eq(min_attr[key.to_sym])
      end
      response.should render_template("show")
      Assembly.count.should == (@num_items+1)
    end
    it 'should not create an item missing any one of the minimum_attributes' do
      FactoryGirl.attributes_for(:assembly_min_create).each do |key, value|
        test_attributes = FactoryGirl.attributes_for(:assembly_min_create)
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        FactoryGirl.attributes_for(:assembly_min_create).size.should == (test_attributes.size+1)
        @num_items = Assembly.count
        post :create, :assembly => test_attributes
        Rails.logger.debug("T assemblies_controller_spec missing one attrib :#{key.to_s}, #{value.to_s}")
        Rails.logger.debug("T assemblies_controller_spec test_attributes :#{test_attributes.inspect.to_s}")
        response.should render_template("new")
        Assembly.count.should == (@num_items)
      end
    end
    it 'should be able to GET edit an item' do
      item1 = FactoryGirl.create(:assembly_min_create)
      get :edit, :id => item1.id
      response.should be_success
      response.should render_template('/edit')
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).should be_instance_of(Assembly) 
      assigns(:assembly).should eq(item1)
    end
    it 'should be able to PUT update an item' do
      item1 = FactoryGirl.create(:assembly_min_create)
      new_attribs = FactoryGirl.attributes_for(:assembly_accessible)
      put :update, :id => item1.id, :assembly => new_attribs
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).should be_persisted
      updated_item = Assembly.find(item1.id)
      updated_item.should_not be_nil
      new_attribs.each  do |key, value|
        Rails.logger.debug("T assembly_controller_spec udpate - match on:#{key.to_s}")
        assigns(:assembly).send(key.to_sym).should eq(new_attribs[key.to_sym])
        updated_item.send(key.to_sym).should eq(new_attribs[key.to_sym])
      end
      response.should render_template("show")
    end
    it 'should be able to GET show an item' do
      item1 = FactoryGirl.create(:assembly_min_create)
      get :show, :id => item1.id
      response.should be_success
      response.should render_template('/show')
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).should be_instance_of(Assembly) 
      assigns(:assembly).should eq(item1)
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
    end
    
    it 'should be able to PUT deactivate an active item' do
      item1 = FactoryGirl.create(:assembly_min_create)
      item1.deactivated?.should be_false
      put :deactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      response.should render_template("show")
      updated_item = Assembly.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = FactoryGirl.create(:assembly_min_create)
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = Assembly.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :deactivate, :id => item1.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:assembly).errors.count.should be > 0
      assigns(:assembly).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:assembly).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = FactoryGirl.create(:assembly_min_create)
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = Assembly.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:assembly).errors.count.should be == 0
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).deactivated?.should be_false
      response.should render_template("show")
      updated_item2 = Assembly.find(item1.id)
      updated_item2.should_not be_nil
      updated_item2.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = FactoryGirl.create(:assembly_min_create)
      item1.deactivated?.should be_false
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:assembly).errors.count.should be > 0
      assigns(:assembly).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:assembly).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:assembly).should_not be_nil
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      item_count = Assembly.count
      item1 = FactoryGirl.create(:assembly_min_create)
      Assembly.count.should == item_count + 1
      item1.deactivated?.should be_false
      delete :destroy, :id => item1.id
      Assembly.count.should == item_count + 1
      # assigns(:assembly).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:assembly).should be_a(Assembly)
      assigns(:assembly).should eq(item1)
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      item1 = FactoryGirl.create(:assembly_min_create)
      item_count = Assembly.count
      Assembly.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == Assembly.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated items
      item1 = FactoryGirl.create(:assembly_min_create)
      item_count = Assembly.count
      Assembly.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      response.should render_template('/index')
      # response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == Assembly.count+1
    end
    it 'should be able to set and clear the show_deactivated flag (item count should be reflected)' do
      item1 = FactoryGirl.create(:assembly_min_create)
      item1.errors.count.should == 0
      item2 = FactoryGirl.create(:assembly_min_create)
      item2.errors.count.should == 0
      item1.deactivate
      item1.errors.count.should == 0
      Assembly.count.should == 2
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      # get :index  # confirm that default startup is to not show deactivated
      response.should be_success
      response.should render_template('/index')
      assigns(:assemblies).size.should == 1
      Assembly.count.should == 2
      get :index, :show_deactivated => DB_TRUE.to_s
      response.should be_success
      response.should render_template('/index')
      Assembly.count.should == 2
      assigns(:assemblies).size.should  == 2
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      Assembly.count.should == 2
      assigns(:assemblies).size.should  == 2
      get :index, :show_deactivated => DB_FALSE.to_s
      response.should be_success
      response.should render_template('/index')
      Assembly.count.should == 2
      assigns(:assemblies).size.should  == 1
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      Assembly.count.should == 2
      assigns(:assemblies).size.should  == 1
    end
  end
  
end
