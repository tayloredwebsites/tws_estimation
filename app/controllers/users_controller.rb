class UsersController < ApplicationController

  before_filter do |controller|
    @errors = safe_params_init({'user' => ['first_name', 'last_name', 'email', 'username']})
    if @errors.count > 0
      render home_errors_path
      return
    else
      @errors = required_params_init({'user' => ['email', 'username']})
      if @errors.count > 0
        render home_errors_path
        return
      end
    end
  
  end
    
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if @user.save
      logger.debug("UsersController.create successfully completed for User = #{@user.id}")
      #redirect_to(:action => 'show', :id => @user.id, :notice => 'User was successfully created!')
      render :action => 'show'
    else
      logger.debug("UsersController.create was unsuccessful")
      render :action => "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #redirect_to(:action => 'show', :id => @user.id, :notice => 'User was successfully created!')
      render :action => 'show'
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_path)
  end
  
  def errors
    redirect_to(home_errors_path)
  end

end
