require 'spec_helper'
include UserTestHelper


describe UsersController do

  describe "GET index" do
    it "assigns all users as @users" do
      user = User.create!(UserTestHelper.user_minimum_create_attributes)
      get :index
      assigns(:users).should eq([user]) # array of all users
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = User.create!(UserTestHelper.user_minimum_create_attributes)
      get :show, :id => user.id.to_s
      assigns(:user).should eq(user) # user being shown
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new
      assigns(:user).should be_a_new(User)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create!(UserTestHelper.user_minimum_create_attributes)
      get :edit, :id => user.id.to_s
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, :user => UserTestHelper.user_minimum_create_attributes
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, :user => UserTestHelper.user_minimum_create_attributes
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        post :create, :user => UserTestHelper.user_minimum_create_attributes
        response.should render_template("show")
        #response.should redirect_to( '/users/1?notice=User+was+successfully+created%21' )
        assigns(:user).should_not be_nil
        assigns(:user).username.should eq(UserTestHelper.user_minimum_create_attributes[:username])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, :user => (UserTestHelper.user_minimum_create_attributes)
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, :user => (UserTestHelper.user_minimum_create_attributes)
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested user as @user" do
        user = User.create!(UserTestHelper.user_minimum_create_attributes)
        put :update, :id => user.id, :user => (UserTestHelper.user_minimum_attributes).merge(user_safe_attributes)
        updated_user = User.find(user.id)
        updated_user.should_not be_nil
        updated_user.username.should eq(user_minimum_attributes[:username])
      end

      it "redirects to the user" do
        user = User.create!(UserTestHelper.user_minimum_create_attributes)
        put :update, :id => user.id, :user => (UserTestHelper.user_minimum_attributes).merge(user_safe_attributes)
        updated_user = User.find(user.id)
        updated_user.should_not be_nil
        updated_user.username.should eq(user_minimum_attributes[:username])
        response.should render_template("show")
      end
    end

    describe "with invalid params" do
      it "renders the 'home/errors' template" do
        user = User.create!(UserTestHelper.user_minimum_create_attributes)
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, :id => user.id.to_s, :user => (UserTestHelper.user_minimum_attributes).merge(user_bad_attributes)
        response.should render_template(home_errors_path)
      end
    end
  end

  it 'deactivate action should deactivate an active user' do
    @user1 = User.create!(UserTestHelper.user_minimum_create_attributes)
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # call the deactivate user action
    put :deactivate, :id => @user1.id
    # response code should be success
    response.should be_success
    response.code.should be == '200'
    # there should be no errors
    assigns(:user).errors.count.should be == 0
    # should be show page after successful deactivate action
    response.should render_template("show")
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
  end

  it 'deactivate action should give an error when deactivating a deactivated user' do
    @user1 = User.create!(UserTestHelper.user_minimum_create_attributes)
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    @user1.errors.count.should be == 0
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # call the deactivate user action
    put :deactivate, :id => @user1.id
    # response code should be success
    response.should be_success
    response.code.should be == '200'
    # there should be errors
    assigns(:user).errors.count.should be > 0
    assigns(:user).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )
    assigns(:user).errors[:deactivated][0].should == I18n.translate('error_messages.is_deactivated')
    # user should still be deactivated
    assigns(:user).should_not be_nil
    assigns(:user).should be_a(User)
    assigns(:user).deactivated.should be_true
    # should be edit page after unsuccessful deactivate action
    response.should render_template("edit")
  end
  
  it 'reactivate action should reactivate an deactivated user' do
    @user1 = User.create!(UserTestHelper.user_minimum_create_attributes)
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # call the reactivate user action
    put :reactivate, :id => @user1.id
    # response code should be success
    response.should be_success
    response.code.should be == '200'
    # there should be no errors
    assigns(:user).errors.count.should be == 0
    # user should be reactivated
    assigns(:user).should_not be_nil
    assigns(:user).should be_a(User)
    assigns(:user).deactivated.should be_false
    # should be show page after successful reactivate action
    response.should render_template("show")
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    # confirm the user is reactivated
    @updated_user.deactivated.should be_false
  end
  
  it 'reactivate action should give an error when reactivating a active user' do
    @user1 = User.create!(UserTestHelper.user_minimum_create_attributes)
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # call the deactivate user action
    put :reactivate, :id => @user1.id
    # response code should be success
    response.should be_success
    response.code.should be == '200'
    # there should be errors
    assigns(:user).errors.count.should be > 0
    assigns(:user).errors[:base][0].should == I18n.translate('errors.cannot_method_msg', :method => 'reactivate', :msg => I18n.translate('error_messages.is_active') )
    assigns(:user).errors[:deactivated][0].should == I18n.translate('error_messages.is_active')
    # user should still be active
    assigns(:user).should_not be_nil
    assigns(:user).should be_a(User)
    assigns(:user).deactivated.should be_false
    # should be edit page after unsuccessful deactivate action
    response.should render_template("edit")
  end
  
  
  context 'all users -' do
    it 'should be able to navigate to the PUT reset_password page'
  end
  
  context 'not logged in (guest user) -' do
    it 'should not be able to navigate to the PUT deactivate page'
    it 'should not be able to navigate to the PUT reactivate page'
    it 'should not be able to navigate to the GET edit_password page'
    it 'should not be able to navigate to the PUT update_password page'
    it 'should not be able to navigate to the GET index page'
    it 'should not be able to navigate to the POST create page'
    it 'should not be able to navigate to the GET new page'
    it 'should not be able to navigate to the GET edit page'
    it 'should not be able to navigate to the GET show page'
    it 'should not be able to navigate to the PUT update page'
    it 'should not be able to navigate to the DELETE destroy page'
  end
  
  context 'logged in user -' do
    it 'should be able to navigate to the PUT deactivate page'
    it 'should be able to navigate to the PUT reactivate page'
    it 'should be able to navigate to the GET edit_password page'
    it 'should be able to navigate to the PUT update_password page'
    it 'should be able to navigate to the GET index page'
    it 'should be able to navigate to the POST create page'
    it 'should be able to navigate to the GET new page'
    it 'should be able to navigate to the GET edit page'
    it 'should be able to navigate to the GET show page'
    it 'should be able to navigate to the PUT update page'
    it 'should be able to navigate to the DELETE destroy page'
  end

end
