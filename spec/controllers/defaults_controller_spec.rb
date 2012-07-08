# spec/controllers/defaults_controller_spec.rb

require 'spec_helper'
include UserTestHelper
include ApplicationHelper

describe DefaultsController do
  
  context 'it should have crud actions available and working' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
    end
    
    it 'should be able to GET the index page and see all items' do
      # user = FactoryGirl.create(:user_min_create_attr)
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item2 = Default.create!(FactoryGirl.attributes_for(:default))
      item3 = Default.create!(FactoryGirl.attributes_for(:default))
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:defaults).count.should == 3
    end
    it 'should be able to GET new item' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:default).should be_instance_of(Default) 
    end
    it "should create an item using POST" do
      @num_items = Default.count
      new_attributes = FactoryGirl.attributes_for(:default)
      post :create, (:default) => new_attributes
      assigns(:default).should_not be_nil
      assigns(:default).should be_instance_of(Default) 
      assigns(:default).should be_persisted
      assigns(:default).name.should eq(new_attributes[:name])
      response.should render_template("show")
      Default.count.should == (@num_items+1)
    end
    it "should create an item with the minimum valid parameters" do
      @num_items = Default.count
      min_attr = FactoryGirl.attributes_for(:default_min)
      post :create, :default => min_attr
      assigns(:default).should_not be_nil
      assigns(:default).should be_a(Default)
      assigns(:default).should be_instance_of(Default) 
      assigns(:default).should be_persisted
      min_attr.each  do |key, value|
        Rails.logger.debug("T defaults_controller_spec minimum - match on:#{key.to_s}")
        assigns(:default).send(key.to_sym).should eq(min_attr[key.to_sym])
      end
      response.should render_template("show")
      Default.count.should == (@num_items+1)
    end
    it 'should not create an item missing any one of the minimum_attributes' do
      FactoryGirl.attributes_for(:default_min).each do |key, value|
        test_attributes = FactoryGirl.attributes_for(:default_min)
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        FactoryGirl.attributes_for(:default_min).size.should == (test_attributes.size+1)
        @num_items = Default.count
        post :create, :default => test_attributes
        response.should render_template("new")
        Default.count.should == (@num_items)
      end
    end
    it 'should be able to GET edit an item' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      get :edit, :id => item1.id.to_s
      response.should be_success
      response.should render_template('/edit')
      assigns(:default).should_not be_nil
      assigns(:default).should be_a(Default)
      assigns(:default).should be_instance_of(Default) 
      assigns(:default).should eq(item1)
    end
    it 'should be able to PUT update an item' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      put :update, :id => item1.id, :default => FactoryGirl.attributes_for(:default).merge({:value => 99.999})
      # assigns(:default).should_not be_nil
      # assigns(:default).should be_a(Default)
      # assigns(:default).value.should == 99.999
      # assigns(:default).should be_persisted
      updated_item = Default.find(item1.id)
      updated_item.should_not be_nil
      updated_item.value.should eq(99.999)
      # response.should render_template("show")
      response.should redirect_to(:controller => 'defaults', :action => 'show')
    end
    it 'should be able to GET show an item' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      get :show, :id => item1.id.to_s
      response.should be_success
      response.should render_template('/show')
      assigns(:default).should_not be_nil
      assigns(:default).should be_a(Default)
      assigns(:default).should be_instance_of(Default) 
      assigns(:default).should eq(item1)
      # assigns(:user).deactivated?.should be_false
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
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      put :deactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      response.should render_template("show")
      updated_item = Default.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = Default.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :deactivate, :id => item1.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:default).errors.count.should be > 0
      assigns(:default).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:default).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:default).should_not be_nil
      assigns(:default).should be_a(Default)
      assigns(:default).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = Default.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:default).errors.count.should be == 0
      assigns(:default).should_not be_nil
      assigns(:default).should be_a(Default)
      assigns(:default).deactivated?.should be_false
      response.should render_template("show")
      updated_item2 = Default.find(item1.id)
      updated_item2.should_not be_nil
      updated_item2.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:default).errors.count.should be > 0
      assigns(:default).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:default).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:default).should_not be_nil
      assigns(:default).should be_a(Default)
      assigns(:default).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      item_count = Default.count
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      Default.count.should == item_count + 1
      item1.deactivated?.should be_false
      delete :destroy, :id => item1.id
      Default.count.should == item_count + 1
      # assigns(:default).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:default).should be_a(Default)
      assigns(:default).should eq(item1)
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item_count = Default.count
      Default.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == Default.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated items
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item_count = Default.count
      Default.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      response.should render_template('/index')
      # response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == Default.count+1
    end
    it 'should be able to set and clear the show_deactivated flag (item count should be reflected)' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.errors.count.should == 0
      item2 = Default.create!(FactoryGirl.attributes_for(:default))
      item2.errors.count.should == 0
      item1.deactivate
      item1.errors.count.should == 0
      Default.count.should == 2
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      # get :index  # confirm that default startup is to not show deactivated
      response.should be_success
      response.should render_template('/index')
      assigns(:defaults).size.should == 1
      Default.count.should == 2
      get :index, :show_deactivated => DB_TRUE.to_s
      response.should be_success
      response.should render_template('/index')
      Default.count.should == 2
      assigns(:defaults).size.should  == 2
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      Default.count.should == 2
      assigns(:defaults).size.should  == 2
      get :index, :show_deactivated => DB_FALSE.to_s
      response.should be_success
      response.should render_template('/index')
      Default.count.should == 2
      assigns(:defaults).size.should  == 1
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      Default.count.should == 2
      assigns(:defaults).size.should  == 1
    end
  end
  
end
