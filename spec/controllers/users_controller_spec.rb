require 'spec_helper'
include UserTestHelper


describe UsersController do

  describe "GET index" do
    it "assigns all users as @users" do
      user = User.create! user_minimum_attributes
      get :index
      assigns(:users).should eq([user]) # array of all users
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = User.create! user_minimum_attributes
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
      user = User.create! user_minimum_attributes
      get :edit, :id => user.id.to_s
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, :user => user_minimum_attributes
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, :user => user_minimum_attributes
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        post :create, :user => user_minimum_attributes
        response.should render_template("show")
        #response.should redirect_to( '/users/1?notice=User+was+successfully+created%21' )
        assigns(:user).should_not be_nil
        assigns(:user).username.should eq(user_minimum_attributes[:username])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, :user => user_minimum_attributes
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, :user => user_minimum_attributes
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested user as @user" do
        user = User.create! user_minimum_attributes
        put :update, :id => user.id, :user => user_minimum_attributes.merge(user_safe_attributes)
        updated_user = User.find(user.id)
        updated_user.should_not be_nil
        updated_user.first_name.should eq(user_safe_attributes[:first_name])
      end

      it "redirects to the user" do
        user = User.create! user_minimum_attributes
        put :update, :id => user.id, :user => user_minimum_attributes.merge(user_safe_attributes)
        updated_user = User.find(user.id)
        updated_user.should_not be_nil
        updated_user.first_name.should eq(user_safe_attributes[:first_name])
        response.should render_template("show")
      end
    end

    describe "with invalid params" do
      it "renders the 'home/errors' template" do
        user = User.create! user_minimum_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, :id => user.id.to_s, :user => user_minimum_attributes.merge(user_bad_attributes)
        response.should render_template(home_errors_path)
      end
    end
  end


end
