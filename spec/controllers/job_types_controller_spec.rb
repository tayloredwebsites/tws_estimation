# spec/controllers/job_types_controller_spec.rb

require 'spec_helper'
include UserTestHelper
include ApplicationHelper

describe JobTypesController do

  context 'it should have crud actions available and working' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      @my_session = session_signin(FactoryGirl.attributes_for(:admin_user_full_create_attr)[:username], FactoryGirl.attributes_for(:admin_user_full_create_attr)[:password])
      @my_session.signed_in?.should be_true
      @my_session.current_user.has_role?('all_admins').should be_true
    end
    
    it 'should be able to GET the index page and see all items' do
      # user = FactoryGirl.create(:user_min_create_attr)
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item2 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item3 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:job_types).count.should == 3
    end
    it 'should be able to GET new item' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:job_type).should be_instance_of(JobType) 
    end
    it "should create an item using POST" do
      @num_items = JobType.count
      new_attributes = FactoryGirl.attributes_for(:job_type)
      post :create, :job_type => new_attributes
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_instance_of(JobType) 
      # assigns(:job_type).should be_persisted
      assigns(:job_type).description.should eq(new_attributes[:description])
      response.should render_template("show")
      JobType.count.should == (@num_items+1)
    end
    it "should create an item with the minimum valid parameters" do
      @num_items = JobType.count
      min_attr = FactoryGirl.attributes_for(:job_type_min)
      post :create, :job_type => min_attr
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).should be_instance_of(JobType) 
      assigns(:job_type).should be_persisted
      min_attr.each  do |key, value|
        Rails.logger.debug("T job_types_controller_spec minimum - match on:#{key.to_s}")
        assigns(:job_type).send(key.to_sym).should eq(min_attr[key.to_sym])
      end
      response.should render_template("show")
      JobType.count.should == (@num_items+1)
    end
    it 'should not create an item missing any one of the minimum_attributes' do
      FactoryGirl.attributes_for(:job_type_min).each do |key, value|
        test_attributes = FactoryGirl.attributes_for(:job_type_min)
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        FactoryGirl.attributes_for(:job_type_min).size.should == (test_attributes.size+1)
        @num_items = JobType.count
        post :create, :job_type => test_attributes
        response.should render_template("new")
        JobType.count.should == (@num_items)
      end
    end
    it 'should be able to GET edit an item' do
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      get :edit, :id => item1.id.to_s
      response.should be_success
      response.should render_template('/edit')
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).should be_instance_of(JobType) 
      assigns(:job_type).should eq(item1)
    end
    it 'should be able to PUT update an item' do
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      put :update, :id => item1.id, :job_type => FactoryGirl.attributes_for(:job_type).merge({:description => 'Newest Description'})
      # assigns(:job_type).should_not be_nil
      # assigns(:job_type).should be_a(JobType)
      # assigns(:job_type).description.should =~ /^Newest Description$/
      # assigns(:job_type).should be_persisted
      updated_item = JobType.find(item1.id)
      updated_item.should_not be_nil
      updated_item.description.should =~ /^Newest Description$/
      # response.should render_template("show")
      response.should redirect_to(:controller => 'job_types', :action => 'show')
    end
    it 'should be able to GET show an item' do
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      get :show, :id => item1.id.to_s
      response.should be_success
      response.should render_template('/show')
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).should be_instance_of(JobType) 
      assigns(:job_type).should eq(item1)
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
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item1.deactivated?.should be_false
      put :deactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      response.should render_template("show")
      updated_item = JobType.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = JobType.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :deactivate, :id => item1.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:job_type).errors.count.should be > 0
      assigns(:job_type).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:job_type).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = JobType.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:job_type).errors.count.should be == 0
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).deactivated?.should be_false
      response.should render_template("show")
      updated_item2 = JobType.find(item1.id)
      updated_item2.should_not be_nil
      updated_item2.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item1.deactivated?.should be_false
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:job_type).errors.count.should be > 0
      assigns(:job_type).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:job_type).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:job_type).should_not be_nil
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      item_count = JobType.count
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      JobType.count.should == item_count + 1
      item1.deactivated?.should be_false
      delete :destroy, :id => item1.id
      JobType.count.should == item_count + 1
      # assigns(:job_type).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:job_type).should be_a(JobType)
      assigns(:job_type).should eq(item1)
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item_count = JobType.count
      JobType.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == JobType.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated items
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item_count = JobType.count
      JobType.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      response.should render_template('/index')
      # response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == JobType.count+1
    end
    it 'should be able to set and clear the show_deactivated flag (item count should be reflected)' do
      item1 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item1.errors.count.should == 0
      item2 = JobType.create!(FactoryGirl.attributes_for(:job_type))
      item2.errors.count.should == 0
      item1.deactivate
      item1.errors.count.should == 0
      JobType.count.should == 2
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      # get :index  # confirm that default startup is to not show deactivated
      response.should be_success
      response.should render_template('/index')
      assigns(:job_types).size.should == 1
      JobType.count.should == 2
      get :index, :show_deactivated => DB_TRUE.to_s
      response.should be_success
      response.should render_template('/index')
      JobType.count.should == 2
      assigns(:job_types).size.should  == 2
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      JobType.count.should == 2
      assigns(:job_types).size.should  == 2
      get :index, :show_deactivated => DB_FALSE.to_s
      response.should be_success
      response.should render_template('/index')
      JobType.count.should == 2
      assigns(:job_types).size.should  == 1
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      JobType.count.should == 2
      assigns(:job_types).size.should  == 1
    end
  end
  
end
