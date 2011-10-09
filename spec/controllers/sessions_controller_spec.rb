require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        # expect {
        #   post :create, :user => UserTestHelper.user_minimum_create_attributes
        # }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        # post :create, :user => UserTestHelper.user_minimum_create_attributes
        # assigns(:user).should be_a(User)
        # assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        # post :create, :user => UserTestHelper.user_minimum_create_attributes
        # response.should render_template("show")
        # #response.should redirect_to( '/users/1?notice=User+was+successfully+created%21' )
        # assigns(:user).should_not be_nil
        # assigns(:user).username.should eq(UserTestHelper.user_minimum_create_attributes[:username])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # User.any_instance.stub(:save).and_return(false)
        # post :create, :user => (UserTestHelper.user_minimum_create_attributes)
        # assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # User.any_instance.stub(:save).and_return(false)
        # post :create, :user => (UserTestHelper.user_minimum_create_attributes)
        # response.should render_template("new")
      end
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      put :destroy
      response.should be_success
    end
  end

end
