class UsersController< SecureApplicationController

  include Controllers::DeactivatedController

  def initialize
    @systemc = 'maint'
    Rails.logger.debug("* UsersController.initialize before super")
    super
  end

  before_filter do |controller|
    # all actions require authentication (so far)
    self.authenticate_user if (%w{ reset_password }.index(params[:action]).nil?)
    @model = User.new
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # Rails.logger.debug ("* UsersController.get_scope - cur_scope in: #{cur_scope}, show_deactivated?: #{show_deactivated?}")
    cur_scope = User.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  def self.list
    self.new.get_scope().order('username')
  end

  def self.list_valid_sales_rep_users(cur_user_id = '')
    Rails.logger.debug("* UsersController.self.list_valid_sales_rep_users cur:#{cur_user_id.inspect.to_s}")
    Rails.logger.debug("* UsersController.self.list_valid_sales_rep_users match:#{(/^\d*$/.match(cur_user_id.to_s)).inspect.to_s}")
    if /^\d+$/.match(cur_user_id.to_s)
      ret = self.new.get_scope().where('id NOT IN (SELECT user_id FROM sales_reps where user_id NOT IN (?))',cur_user_id).order('username')
      # ret = self.new.get_scope().where('id NOT IN (SELECT user_id FROM sales_reps where id NOT IN (?)) AND id IS NOT NULL',cur_user_id).order('username')
      Rails.logger.debug("* UsersController.self.list_valid_sales_rep_users cur:#{cur_user_id.to_s}, ret:#{ret.inspect.to_s}")
    else
      ret = self.new.get_scope().where('id NOT IN (SELECT user_id FROM sales_reps) AND id IS NOT NULL').order('username')
      Rails.logger.debug("* UsersController.self.list_valid_sales_rep_users ret:#{ret.inspect.to_s}")
    end
    ret
 end

  # GET /users
  def index
    @users = get_scope().order('username')
    authorize! :index, @users   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/list
  def list
    @users = get_scope().order('last_name, first_name')
    authorize! :index, @users   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/1
  def show
    @user = get_scope().find(params[:id])
    authorize! :show, @user   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/new
  def new
    @user = User.new
    authorize! :new, @user   # authorize from CanCan::ControllerAdditions
  end

  # GET /users/1/edit
  def edit
    @user = get_scope().find(params[:id])
    authorize! :edit, @user   # authorize from CanCan::ControllerAdditions
  end

  def create
    authorize! :create, @model   # authorize from CanCan::ControllerAdditions
    @user = User.new(params[:user])
    @user.save
    if @user.errors.count == 0
      notify_success( I18n.translate('errors.success_method_obj_name',
        :method => params[:action],
        :obj => @model.class.name,
        :name => @user.username )
      )
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  def update
    @user = get_scope().find(params[:id])
    if (!@user.nil?)
      authorize! :update, @user   # authorize from CanCan::ControllerAdditions
      valid_user_params = self.validate_self_update()
      @user.update_attributes(valid_user_params)
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

  def validate_self_update
    Rails.logger.debug("* UsersController.validate_self_update started - test:#{current_user.id.to_s == params[:id].to_s}")
    working_params = params[:user].dup
    if current_user.id.to_s == params[:id].to_s
      # if user admin( user has one of USER_SELF_UPDATE_ROLES), let them update all of their fields
      # otherwise only let them update the USER_SELF_NO_UPDATE_FIELDS.
      # to do # split out roles code into user_roles.rb
      working_params.delete_if{|key,value| !USER_SELF_NO_UPDATE_FIELDS.index(key).nil?} if (current_user.roles.split(' ') & USER_SELF_UPDATE_ROLES).size == 0
      if params[:user].size != working_params.size
        err = I18n.translate('errors.cannot_method_your_obj', :method => params[:action], :obj => USER_SELF_NO_UPDATE_FIELDS.join(' or ').to_s)
        @user.errors.add(:roles, err)
      end
    end
    return working_params
  end

  # DELETE /users/:id
  def destroy
    super # call to parent (including Controllers::DeactivatedController)
  end

  # GET /users/1/edit_password
  def edit_password
    @user = get_scope().find(params[:id])
    authorize! :edit_password, @user   # authorize from CanCan::ControllerAdditions
  end

  # PUT /users/:id/update_password
  def update_password
    @user = get_scope().find(params[:id])
    if (!@user.nil?)
      authorize! :update_password, @user   # authorize from CanCan::ControllerAdditions
      if !@user.valid_password_change?(params[:user])
        Rails.logger.error("E UsersController - update_password - not valid_password_change - params:#{params[:user]}")
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
