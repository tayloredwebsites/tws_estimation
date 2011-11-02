class UsersController< SecureApplicationController

  before_filter do |controller|
    # self.load_session
    # logger.debug('Sessions Controller filter = '+%w{ index show new create edit update destroy deactivate reactivate }.index(params[:action]).to_s)
    # all actions require authentication (so far)
    self.authenticate_user  # if !(%w{ index show new create edit update destroy deactivate reactivate }.index(params[:action]).nil?)
    @model = User.new
    @errors = Array.new
  end
    
  before_filter do |controller|
    @model = User.new
    # if %w(show edit update destroy delete deactivate reactivate).include?(params[:action])
    #   @model = @user = User.find(params[:id])
    # elsif params[:action]  == new
    #   @model = @user = User.new
    # elsif params[:action]  == create
    #   @model = @user = User.new(params[:user])
    # elsif params[:action]  == index
    #   @users = User.all
    #   @model = User.new
    # end
    # @errors = safe_params_init(@model, {'user' => ['first_name', 'last_name', 'email', 'username', 'deactivated']})
    @errors = safe_params_init({'user' => %w(first_name last_name email username deactivated password password_confirmation old_password)})
    @errors = required_params_init({'user' => ['email', 'username']}) if @errors.count == 0
    # @errors = validate_login_status
    if @errors.count > 0
      render home_errors_path
      return
    end
  
  end
    
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # def create
  #   @user = User.new(params[:user])
  #   if @user.save
  #     notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
  #     render :action => 'show'
  #   else
  #     logger.debug("UsersController.create was unsuccessful")
  #     render :action => "new"
  #   end
  # end
  def create
    @user = User.new(params[:user])
    @user.save
    # @user = User.create!(params[:user])
    if @user.errors.count == 0
      # notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
      render :action => 'show'
    else
      # logger.errors("UsersController.create was unsuccessful")
      # @user.errors.each do |attr, msg|
      #   logger.debug("User create error: "+msg)
      # end
      render :action => "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
      render :action => 'show'
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
      render :action => 'index'
    else
    	if @user.errors[:base].count > 0
    	  notify_error( @user.errors[:base][0] )
    	else
    	  notify_error("Error deleting user #{@user.username}")
    	end
      render :action => 'edit', :id => @user.id
    end
  end
  
  # GET /users/:id/deactivate
  def deactivate
    @user = User.find(params[:id])
    if @user.deactivate
      notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
      render :action => 'show', :id => @user.id
    else
    	if @user.errors[:base].count > 0
    	  notify_error( @user.errors[:base][0] )
    	else
    	  notify_error("Error deactivating user #{@user.username}")
    	end
      # @user.errors.add(:base, "error deactivating User")
      render :action => 'edit', :id => @user.id
    end
  end
  
  # GET /users/:id/reactivate
  def reactivate
    @user = User.find(params[:id])
    if @user.reactivate
      notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
      render :action => 'show', :id => @user.id
    else
    	if @user.errors[:base].count > 0
    	  notify_error( @user.errors[:base][0] )
    	else
        notify_error("Error reactivating user #{@user.username}")
      end
      # @user.errors.add(:base, "error reactivating User")
      render :action => 'edit', :id => @user.id
    end
  end
  
  # GET /users/1/edit_password
  def edit_password
    @user = User.find(params[:id])
  end

  # PUT /users/:id/update_password
  def update_password
    @user = User.find(params[:id])
    # should this bomb out ????????
    if @user.update_attributes(params[:user])
      notify_success( I18n.translate('errors.success_method_obj_name', :method => params[:action], :obj => @model.class.name, :name => @user.username ) )
      render :action => 'show'
    else
      render :action => "edit_password"
    end
    # shouldn't this call a model class update_password, for security's sake ?????????
  end
  
  def validate_login_status
    
  end
  
  def errors
    redirect_to(home_errors_path)
  end

end
