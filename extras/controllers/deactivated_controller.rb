module Controllers::DeactivatedController
  # module to add deactivated field to a controller
  
  # unnecessary
  def initialize(*args)
    Rails.logger.debug("* .DeactivatedController.initialize args:#{args.inspect.to_s}")
    super(*args)
  end
  
  # Possible to add before filters to base class for this module
  # not used - prefer to call get_scoped_users from class before filter for readability
  def self.included(base)
    Rails.logger.debug("* .DeactivatedController.self.included - base class name:#{base.name}")
    # base.before_filter do |controller|
    # end
    
  end

  # update current scope chain with deactivation scope
  def get_scope(users_scope)
    if show_deactivated?
      Rails.logger.debug("* Controllers::DeactivatedController.get_scope show_deactivated == true")
      return users_scope
    else
      Rails.logger.debug("* Controllers::DeactivatedController.get_scope show_deactivated == false")
      return users_scope.where("deactivated = ? or deactivated IS NULL", false)
    end
  end
  
  # GET /users/:id/deactivate
  def deactivate
    Rails.logger.debug("* UsersController - deactivate - authorize")
    @user = @users_scoped.find(params[:id])
    if (!@user.nil?)
      authorize! :deactivate, @user   # authorize from CanCan::ControllerAdditions
      if @user.deactivate
        notify_success( I18n.translate('errors.success_method_obj_name',
          :method => params[:action],
          :obj => @model.class.name,
          :name => @user.username )
        )
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
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end
  
  # GET /users/:id/reactivate
  def reactivate
    Rails.logger.debug("* UsersController - reactivate - authorize")
    @user = @users_scoped.find(params[:id])
    if (!@user.nil?)
      authorize! :reactivate, @user   # authorize from CanCan::ControllerAdditions
      if @user.reactivate
        notify_success( I18n.translate('errors.success_method_obj_name',
          :method => params[:action],
          :obj => @model.class.name,
          :name => @user.username )
        )
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
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end
  
end