class UsersController< SecureApplicationController

  include Controllers::DeactivatedController
  
  def initialize
    @systemc = 'maint'
    Rails.logger.debug("* UsersController.initialize before super - systemc:#{@systemc.to_s}")
    super
  end

  before_filter do |controller|
    # all actions require authentication (so far)
    self.authenticate_user if (%w{ reset_password }.index(params[:action]).nil?)
    @model = User.new
    #Rails.logger.debug("* UsersController.before_filter @user_session:#{@user_session.inspect.to_s}")
    Rails.logger.debug("* UsersController.before_filter @user_session.info('show_deactivated'):#{@user_session.info('show_deactivated').inspect.to_s}")
    @users_scoped = get_scope(User.scoped)
    Rails.logger.debug("* UsersController.before_filter for #{params[:action]} show_deactivated? = #{show_deactivated?}")
    Rails.logger.debug("* UsersController.before_filter for #{params[:action]} @users_scoped = #{@users_scoped.all}")
  end
  
  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope)
    if defined?(super)
      Rails.logger.debug("* UsersController.get_scope super scope=#{super(cur_scope).all} ")
      return super(cur_scope)
    else
      Rails.logger.debug("* UsersController.get_scope no super scope=#{cur_scope.all} ")
      return cur_scope
    end
  end
    
  # GET /users
  def index
    #Rails.logger.debug("* UsersController.index - @users_scoped:#{@users_scoped.inspect.to_s}")
    #Rails.logger.debug("* UsersController.index - User.find(:all):#{User.find(:all).inspect.to_s}")
    @users = @users_scoped.all
    #Rails.logger.debug("* UsersController.index - @users:#{@users.inspect.to_s}")
    authorize! :index, @users   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/1
  def show
    @user = @users_scoped.find(params[:id])
    Rails.logger.debug("* UsersController - show @user:#{@user.inspect.to_s}")
    authorize! :show, @user   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/new
  def new
    @user = User.new
    authorize! :new, @user   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/1/edit
  def edit
    @user = @users_scoped.find(params[:id])
    Rails.logger.debug("* UsersController - edit - @user:(#{@user.inspect.to_s})")
    #Rails.logger.debug("* UsersController - edit - ability.can?(:edit, @user):#{Ability.new(@user).can?(:edit, @user)}") # see if user can access the user
    #Rails.logger.debug("* UsersController - edit - current_user.id:#{current_user.id.to_s} ==? @user.id:#{@user.id.to_s} => #{current_user.id.to_s == @user.id.to_s}")
    authorize! :edit, @user   # authorize from CanCan::ControllerAdditions
  end

  def create
    Rails.logger.debug("* UsersController - create - user:(#{params[:user].inspect.to_s})")
    @user = User.new(params[:user])
    if (!@user.nil?)
      authorize! :create, @user   # authorize from CanCan::ControllerAdditions
      #Rails.logger.debug("* UsersController - create - save")
      @user.save
      # @user = User.create!(params[:user])
      if @user.errors.count == 0
        render :action => 'show'
      else
        render :action => "new"
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end

  # PUT /users/1
  def update
    Rails.logger.debug("* UsersController - update - authorize")
    # Rails.logger.debug("* UsersController - update - params[:user]=#{params[:user].inspect.to_s}")
    @user = @users_scoped.find(params[:id])
    if (!@user.nil?)
      # Rails.logger.debug("* UsersController - update - params[:user]=#{params[:user].inspect.to_s}")
      authorize! :update, @user   # authorize from CanCan::ControllerAdditions
      # Rails.logger.debug("* UsersController - update - params[:user]=#{params[:user].inspect.to_s}")
      working_params = params[:user].clone
      # Rails.logger.debug("* UsersController - update - params[:user]=#{working_params.inspect.to_s}")
      # is this a self update?
      Rails.logger.debug("* UsersController - update - self update?#{current_user.id.to_s} == #{params[:id]} => #{current_user.id.to_s == params[:id].to_s}")
      if current_user.id.to_s == params[:id].to_s
        # if user admin( user has one of USER_SELF_UPDATE_ROLES), let them update all of their fields
        # otherwise only let them update the USER_SELF_NO_UPDATE_FIELDS.
        working_params.delete_if{|key,value| !USER_SELF_NO_UPDATE_FIELDS.index(key).nil?} if (current_user.roles.split(' ') & USER_SELF_UPDATE_ROLES).size == 0
        #Rails.logger.debug("* UsersController - update - updated user params:#{working_params}, sizes:#{params[:user].size} ==? #{working_params.size} ")
        if params[:user].size != working_params.size
          err = I18n.translate('errors.cannot_method_your_obj', :method => params[:action], :obj => USER_SELF_NO_UPDATE_FIELDS.join(' or ').to_s) 
          @user.errors.add(:roles, err)
          #Rails.logger.debug("* UsersController - update error - #{err}")
        end
      end
      if working_params[:roles].instance_of?(Array)
        #Rails.logger.debug("* UsersController - update - roles is an array:#{working_params[:roles]}")
        working_params[:roles] = working_params[:roles].join(' ')
      end
      @user.update_attributes(working_params)
      if @user.errors.count == 0
        notify_success( I18n.translate('errors.success_method_obj_name',
          :method => params[:action],
          :obj => @model.class.name,
          :name => @user.username )
        )
        render :action => 'show'
      else
        render :action => "edit"
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end

  # DELETE /users/:id
  def destroy
    @user = @users_scoped.find(params[:id])
    Rails.logger.debug("* UsersController.destroy #{@model.class.name} with id:#{params[:id]}")
    Rails.logger.debug("* UsersController.destroy #{@model.class.name} with @users_scoped:#{@users_scoped.inspect.to_s}")
    if (!@user.nil?)
      Rails.logger.debug("* UsersController.destroy #{@model.class.name} with @user:#{@user.inspect.to_s}")
      authorize! :delete, @user   # authorize from CanCan::ControllerAdditions
      if @user.destroy
        notify_success( I18n.translate('errors.success_method_obj_name',
          :method => params[:action],
          :obj => @model.class.name,
          :name => @user.username )
        )
        render :action => 'index'
      else
      	if @user.errors[:base].count > 0
      	  notify_error( @user.errors[:base][0] )
      	else
      	  notify_error("Error deleting user #{@user.username}")
      	end
        render :action => 'edit', :id => @user.id
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end
  
  # GET /users/1/edit_password
  def edit_password
    Rails.logger.debug("* UsersController - edit_password - authorize - params[:id]:#{params[:id].to_s} == session[:current_user_id]:#{session[:current_user_id].to_s}")
    @user = @users_scoped.find(params[:id])
    authorize! :edit_password, @user   # authorize from CanCan::ControllerAdditions
  end

  # PUT /users/:id/update_password
  def update_password
    Rails.logger.debug("* UsersController - update_password - authorize")
    @user = @users_scoped.find(params[:id])
    if (!@user.nil?)
      authorize! :update_password, @user   # authorize from CanCan::ControllerAdditions
      if !@user.valid_password_change?(params[:user])
        Rails.logger.debug("* UsersController - update_password - not valid_password_change - params:#{params[:user]}")
        render :action => 'edit_password'
      else
        if @user.update_attributes(params[:user])
          notify_success( I18n.translate('errors.success_method_obj_name',
            :method => params[:action],
            :obj => @model.class.name,
            :name => @user.username )
          )
          render :action => 'show'
        else
          render :action => "edit_password"
        end
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end
  
#  def reset_password
#     Rails.logger.debug("* UsersController.reset_password - params:#{params.inspect.to_s}")
#     @user = User.find(:first, :conditions => ['email = ? OR username = ?', params[:user][:email].to_s, params[:user][:username].to_s ] )
#     authorize! :reset_password, @user   # authorize from CanCan::ControllerAdditions
#     Rails.logger.debug('users_controller.reset_password - email='+ params[:user][:email].to_s+', username='+params[:user][:username].to_s)
#     if @user.nil?
#       notify_error( I18n.translate('errors.cannot_find_obj', :obj => @model.class.name) )
#       redirect_to(home_errors_path)
#     else
#       @user.reset_password
#       # must remove search parameters so that they are not used to update the record
#       params[:user].delete(:email)
#       params[:user].delete(:username)
#       logger.debug('before update_attributes - params[:user]:'+params[:user].to_s)
#       if @user.update_attributes(params[:user])
#         notify_success( I18n.translate('errors.success_method_obj_name',
#           :method => params[:action],
#           :obj => @model.class.name,
#           :name => @user.username )
#         )
#         render :action => 'show'
#       else
#         logger.debug('reset_password errors='+@user.errors.to_s)
#         redirect_to(home_errors_path)
#       end
#     end
#   end

end
