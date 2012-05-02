module Controllers::DeactivatedController
  # module to add deactivated field to a controller
  
  # unnecessary
  def initialize
    # Rails.logger.debug("* Controllers::DeactivatedController.initialize - args:#{args.inspect.to_s}")
    super
  end

  # update current scope chain with deactivation scope
  def get_scope(cur_scope)
    # nust have scope here, from the controller child call to super inside get_scope
    Rails.logger.debug ("* Controllers::DeactivatedController.get_scope - cur_scope in: #{cur_scope}, show_deactivated?: #{show_deactivated?}")
    Rails.logger.debug ("* Controllers::DeactivatedController.get_scope - controller name: #{self.controller_name}")
    return (show_deactivated?) ? cur_scope : cur_scope.where("#{self.controller_name}.deactivated = ? or #{self.controller_name}.deactivated IS NULL", false)
  end
  
  # attempt to get model class name corresponding to this controller from the 1) scope, 2) @model instance or 3) from controller name
  def get_model_name(params = nil)
    if get_scope.size > 0
      get_scope.first.class.name_underscore
    elsif !@model.nil?
      @model.class.name.underscore
    elsif !params.nil?
      params[:controller].singularize
    else
      Rails.logger.error("E Controllers::DeactivatedController.get_model_name - cannot get model name from scope, @model or controller name")
      ''
    end
  end
      
  # GET /(controller)/:id/deactivate
  def deactivate
    Rails.logger.debug("* Controllers::DeactivatedController.deactivate - call get_scope")
    item = get_scope().find(params[:id])
    if (!item.nil?)
      authorize! :deactivate, item   # authorize from CanCan::ControllerAdditions
      if item.deactivate
        notify_success( I18n.translate('errors.success_method_obj_id',
          :method => params[:action],
          :obj => item.class.name,
          :id => item.id )
        )
        Rails.logger.debug("* Controllers::DeactivatedController.deactivate - deactivated? = #{item.deactivated?}")
        Rails.logger.debug("* Controllers::DeactivatedController.deactivate - return instance variable #{'@'+item.class.name.underscore}")
        # self.instance_variable_set('@'+item.class.name.underscore.pluralize, get_scope() )
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => 'show', :id => item.id
        # self.instance_variable_set('@'+item.class.name.underscore.pluralize, get_scope() )
        # # don't show deactivated item (edit button no good if show_deactivated false), better to show item gone
        # redirect_to components_path
      else
          if item.errors[:base].count > 0
            notify_error( item.errors[:base][0] )
          else
            notify_error("Error deactivating #{item.class.name} #{item.id}")
          end
        # @user.errors.add(:base, "error deactivating item")
        Rails.logger.debug("* Controllers::DeactivatedController.deactivate - return instance variable #{'@'+item.class.name.underscore}")
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => 'edit', :id => item.id
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{get_model_name(params)}.id:#{params[:id]} when not in scope")
    end
  end
  
  # GET /(controller)/:id/reactivate
  def reactivate
    item = get_scope().find(params[:id])
    if (!item.nil?)
      authorize! :reactivate, item   # authorize from CanCan::ControllerAdditions
      if item.reactivate
        notify_success( I18n.translate('errors.success_method_obj_id',
          :method => params[:action],
          :obj => item.class.name,
          :id => item.id )
        )
        Rails.logger.debug("* Controllers::DeactivatedController.reactivate - return instance variable #{'@'+item.class.name.underscore}")
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => 'show', :id => item.id
      else
          if item.errors[:base].count > 0
            notify_error( item.errors[:base][0] )
          else
          notify_error("Error reactivating #{item.class.name} #{item.id}")
        end
        # @user.errors.add(:base, "error reactivating item")
        Rails.logger.debug("* Controllers::DeactivatedController.reactivate - return instance variable #{'@'+item.class.name.underscore}")
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => 'edit', :id => item.id
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{get_model_name(params)}.id:#{params[:id]} when not in scope")
    end
  end
  
  # DELETE (DESTROY) /(controller)/:id
  def destroy
    my_scope = get_scope()
    item = my_scope.find(params[:id])
    Rails.logger.debug("* Controllers::DeactivatedController.destroy #{item.class.name} with id:#{params[:id]}")
    if (!item.nil?)
      Rails.logger.debug("* Controllers::DeactivatedController.destroy #{item.class.name} with item:#{item.inspect.to_s}")
      authorize! :delete, item   # authorize from CanCan::ControllerAdditions
      if item.destroy
        notify_success( I18n.translate('errors.success_method_obj_id',
          :method => params[:action],
          :obj => item.class.name,
          :id => item.id )
        )
        Rails.logger.debug("* Controllers::DeactivatedController.destroy - return instance variable #{'@'+item.class.name.underscore.pluralize}")
       self.instance_variable_set('@'+item.class.name.underscore.pluralize, my_scope.all)
        render :action => 'index'
      else
        Rails.logger.debug("* Controllers::DeactivatedController.destroy errors.count: #{item.errors.count.to_s}")
          if item.errors[:base].count > 0
            Rails.logger.debug("* Controllers::DeactivatedController.destroy errors: #{item.errors.inspect.to_s}")
            notify_error( item.errors[:base][0] )
          else
            Rails.logger.debug("* Controllers::DeactivatedController.destroy Error deleting #{item.class.name} with ID #{item.id}")
            notify_error("Error deleting #{item.class.name} with ID #{item.id}")
          end
        Rails.logger.debug("* Controllers::DeactivatedController.destroy - return instance variable #{'@'+item.class.name.underscore}")
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => 'edit', :id => item.id
      end
    else
      Rails.logger.error("E Controllers::DeactivatedController Attempt to #{params[:action]} #{get_model_name(params)}.id:#{params[:id]} when not in scope - e.g. deactivated")
      redirect_to(home_errors_path)
    end
  end

  # PUT /(controller)/:id
  def update
    my_scope = get_scope()
    item = my_scope.find(params[:id])
    if (!item.nil?)
      # Rails.logger.debug("* Controllers::DeactivatedController.update - found item:#{item.inspect.to_s}")
      authorize! :update, item   # authorize from CanCan::ControllerAdditions
      item.update_attributes(params[item.class.name.underscore.to_sym].dup)
      # Rails.logger.debug("* Controllers::DeactivatedController.update - user after update attributes:#{item.inspect.to_s}")
      if item.errors.count == 0
        notify_success( I18n.translate('errors.success_method_obj_id',
          :method => params[:action],
          :obj => item.class.name,
          :id => item.id )
        )
        Rails.logger.debug("* Controllers::DeactivatedController.update - return instance variable #{'@'+item.class.name.underscore}")
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => 'show'
      else
        Rails.logger.debug("* Controllers::DeactivatedController.update - return instance variable #{'@'+item.class.name.underscore}")
        self.instance_variable_set('@'+item.class.name.underscore, item)
        render :action => "edit"
      end
    else
      Rails.logger.error("E Controllers::DeactivatedController Attempt to #{params[:action]} #{get_model_name(params)}.id:#{params[:id]} when not in scope")
      redirect_to(home_errors_path)
    end
  end

end