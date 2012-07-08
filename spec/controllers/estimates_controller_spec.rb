# spec/controllers/estimates_controller_spec.rb

require 'spec_helper'
include UserTestHelper
include ApplicationHelper

describe EstimatesController do

  def prep_estimate_create
    @job_type = JobType.create!(FactoryGirl.attributes_for(:job_type))
    @state = State.create!(FactoryGirl.attributes_for(:state))
    @user1 = User.create!(FactoryGirl.attributes_for(:user_create))
    @sales_rep1 = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user1.id))
    @user2 = User.create!(FactoryGirl.attributes_for(:user_create))
    @sales_rep2 = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user2.id))
  end

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
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      item2 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep2, :job_type => @job_type, :state => @state )
      Estimate.count.should == 2
      get :index
      response.should be_success
      response.should render_template('/index')
      assigns(:estimates).count.should == 2
    end
    it 'should be able to GET new item' do
      get :new
      response.should be_success
      response.should render_template('/new')
      assigns(:estimate).should be_instance_of(Estimate) 
    end
    it "should create an item using POST" do
      @num_items = Estimate.count
      prep_estimate_create
      new_attributes = generate_estimate_accessible_attributes( :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      post :create, :estimate => new_attributes
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_instance_of(Estimate) 
      assigns(:estimate).should be_persisted
      new_attributes.each  do |key, value|
        Rails.logger.debug("T estimates_controller_spec minimum - match on:#{key.to_s}")
        assigns(:estimate).send(key.to_sym).should eq(new_attributes[key.to_sym])
      end
      response.should render_template("show")
      Estimate.count.should == (@num_items+1)
    end
    it "should create an item with the minimum valid parameters" do
      @num_items = Estimate.count
      min_attr = generate_estimate_min_attributes( :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      post :create, :estimate => min_attr
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_instance_of(Estimate) 
      assigns(:estimate).should be_persisted
      min_attr.each  do |key, value|
        Rails.logger.debug("T estimates_controller_spec minimum - match on:#{key.to_s}")
        assigns(:estimate).send(key.to_sym).should eq(min_attr[key.to_sym])
      end
      response.should render_template("show")
      Estimate.count.should == (@num_items+1)
    end
    it 'should not create an item missing any one of the minimum_attributes' do
      all_attributes = generate_estimate_min_attributes( :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      all_attributes.each do |key, value|
        test_attributes = all_attributes.clone
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        all_attributes.size.should == (test_attributes.size+1)
        @num_items = Estimate.count
        post :create, :estimate => test_attributes
        Rails.logger.debug("T estimates_controller_spec missing one attrib :#{key.to_s}, #{value.to_s}")
        Rails.logger.debug("T estimates_controller_spec test_attributes :#{test_attributes.inspect.to_s}")
        response.should render_template("new")
        Estimate.count.should == (@num_items)
      end
    end
    it 'should be able to GET edit an item' do
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      get :edit, :id => item1.id
      response.should be_success
      response.should render_template('/edit')
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_a(Estimate)
      assigns(:estimate).should be_instance_of(Estimate) 
      assigns(:estimate).should eq(item1)
    end
    it 'should be able to PUT update an item' do
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      new_attribs = FactoryGirl.attributes_for(:estimate_accessible)
      put :update, :id => item1.id, :estimate => new_attribs
      # assigns(:estimate).should_not be_nil
      # assigns(:estimate).should be_a(Estimate)
      # assigns(:estimate).should be_persisted
      updated_item = Estimate.find(item1.id)
      updated_item.should_not be_nil
      new_attribs.each  do |key, value|
        Rails.logger.debug("T assembly_controller_spec udpate - match on:#{key.to_s}")
        # assigns(:estimate).send(key.to_sym).should eq(new_attribs[key.to_sym])
        updated_item.send(key.to_sym).should eq(new_attribs[key.to_sym])
      end
      response.should render_template("show")
      # response.should redirect_to(:controller => 'assemblies', :action => 'show')
    end
    it 'should be able to GET show an item' do
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      get :show, :id => item1.id
      response.should be_success
      response.should render_template('/show')
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_a(Estimate)
      assigns(:estimate).should be_instance_of(Estimate) 
      assigns(:estimate).should eq(item1)
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
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      item1.deactivated?.should be_false
      put :deactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      response.should render_template("show")
      updated_item = Estimate.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
    end
    it 'should give an error when PUT deactivating a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = Estimate.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :deactivate, :id => item1.id
      #response.should be_success
      #response.code.should be == '200'
      assigns(:estimate).errors.count.should be > 0
      assigns(:estimate).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
      assigns(:estimate).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_a(Estimate)
      assigns(:estimate).deactivated?.should be_true
      response.should render_template("edit")
    end
    it 'should be able to PUT reactivate a deactivated user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      item1.deactivated?.should be_false
      item1.deactivate
      item1.errors.count.should be == 0
      updated_item = Estimate.find(item1.id)
      updated_item.should_not be_nil
      updated_item.deactivated?.should be_true
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:estimate).errors.count.should be == 0
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_a(Estimate)
      assigns(:estimate).deactivated?.should be_false
      response.should render_template("show")
      updated_item2 = Estimate.find(item1.id)
      updated_item2.should_not be_nil
      updated_item2.deactivated?.should be_false
    end
    it 'should give an error when reactivating a active user' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see the item we deactivate
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == 1
      item1.deactivated?.should be_false
      put :reactivate, :id => item1.id
      response.should be_success
      response.code.should be == '200'
      assigns(:estimate).errors.count.should be > 0
      assigns(:estimate).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
      assigns(:estimate).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
      assigns(:estimate).should_not be_nil
      assigns(:estimate).should be_a(Estimate)
      assigns(:estimate).deactivated?.should be_false
      response.should render_template("edit")
    end
    it 'should not be able to DELETE destroy an active user' do
      item_count = Estimate.count
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      Estimate.count.should == item_count + 1
      item1.deactivated?.should be_false
      delete :destroy, :id => item1.id
      Estimate.count.should == item_count + 1
      # assigns(:estimate).errors.count.should > 0
      response.should render_template('/edit')
      assigns(:estimate).should be_a(Estimate)
      assigns(:estimate).should eq(item1)
    end
    it 'should not be able to DELETE destroy a deactivated user if show_deactivated is false' do
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      item_count = Estimate.count
      Estimate.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      #response.should render_template('/index')
      response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == Estimate.count
    end
    it 'should be able to DELETE destroy a deactivated user if show_deactivated is true' do
      get :index, :show_deactivated => "true" # set show deactivated session flag so we can see deactivated items
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      item_count = Estimate.count
      Estimate.count.should == 1
      item1.deactivate
      item1.errors.count.should == 0
      delete :destroy, :id => item1.id
      response.should render_template('/index')
      # response.should redirect_to(:controller => 'home', :action => 'errors')
      item_count.should == Estimate.count+1
    end
    it 'should be able to set and clear the show_deactivated flag (item count should be reflected)' do
      prep_estimate_create
      item1 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep1, :job_type => @job_type, :state => @state )
      item1.errors.count.should == 0
      item2 = FactoryGirl.create(:estimate, :sales_rep => @sales_rep2, :job_type => @job_type, :state => @state )
      item2.errors.count.should == 0
      item1.deactivate
      item1.errors.count.should == 0
      Estimate.count.should == 2
      get :index, :show_deactivated => "false" # set show deactivated session flag so we cannot see deactivated items
      # get :index  # confirm that default startup is to not show deactivated
      response.should be_success
      response.should render_template('/index')
      assigns(:estimates).size.should == 1
      Estimate.count.should == 2
      get :index, :show_deactivated => DB_TRUE.to_s
      response.should be_success
      response.should render_template('/index')
      Estimate.count.should == 2
      assigns(:estimates).size.should  == 2
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      Estimate.count.should == 2
      assigns(:estimates).size.should  == 2
      get :index, :show_deactivated => DB_FALSE.to_s
      response.should be_success
      response.should render_template('/index')
      Estimate.count.should == 2
      assigns(:estimates).size.should  == 1
      get :index  # run again to confirm the show_deactivated sticks
      response.should be_success
      response.should render_template('/index')
      Estimate.count.should == 2
      assigns(:estimates).size.should  == 1
    end
  end

end
