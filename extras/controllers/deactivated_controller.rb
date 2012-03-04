module Controllers::DeactivatedController
  # module to add deactivated field to a controller
  
  # unnecessary
  def initialize(*args)
    # Rails.logger.debug("* .DeactivatedController.initialize args:#{args.inspect.to_s}")
    super(*args)
  end

  # update current scope chain with deactivation scope
  def get_scope(cur_scope)
    Rails.logger.debug ("* Controllers::DeactivatedController.get_scope - cur_scope in: #{cur_scope}, show_deactivated?: #{show_deactivated?}")
    return (show_deactivated?) ? cur_scope : cur_scope.where("deactivated = ? or deactivated IS NULL", false)
  end
  
  # GET /(controller)/:id/deactivate
  def deactivate
    Rails.logger.debug("* Controllers::DeactivatedController.deactivate - call get_scope")
    # item = @scoped_list.find(params[:id])
    item = get_scope(nil).find(params[:id])
    if (!item.nil?)
      authorize! :deactivate, item   # authorize from CanCan::ControllerAdditions
      if item.deactivate
        notify_success( I18n.translate('errors.success_method_obj_id',
          :method => params[:action],
          :obj => item.class.name,
          :id => item.id )
        )
        Rails.logger.debug("* Controllers::DeactivatedController - deactivate - return instance variable #{'@'+@model.class.name.downcase}")
        self.instance_variable_set('@'+@model.class.name.downcase, item)
        render :action => 'show', :id => item.id
      else
      	if item.errors[:base].count > 0
      	  notify_error( item.errors[:base][0] )
      	else
      	  notify_error("Error deactivating #{item.class.name} #{item.id}")
      	end
        # @user.errors.add(:base, "error deactivating item")
        Rails.logger.debug("* Controllers::DeactivatedController - deactivate - return instance variable #{'@'+@model.class.name.downcase}")
        self.instance_variable_set('@'+@model.class.name.downcase, item)
        render :action => 'edit', :id => item.id
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{item.class.name}.id:#{params[:id]} when not in scope")
    end
  end
  
  # GET /(controller)/:id/reactivate
  def reactivate
    # item = @scoped_list.find(params[:id])
    item = get_scope(nil).find(params[:id])
    if (!item.nil?)
      authorize! :reactivate, item   # authorize from CanCan::ControllerAdditions
      if item.reactivate
        notify_success( I18n.translate('errors.success_method_obj_id',
          :method => params[:action],
          :obj => item.class.name,
          :id => item.id )
        )
        Rails.logger.debug("* Controllers::DeactivatedController - reactivate - return instance variable #{'@'+@model.class.name.downcase}")
        self.instance_variable_set('@'+@model.class.name.downcase, item)
        render :action => 'show', :id => item.id
      else
      	if item.errors[:base].count > 0
      	  notify_error( item.errors[:base][0] )
      	else
          notify_error("Error reactivating #{item.class.name} #{item.id}")
        end
        # @user.errors.add(:base, "error reactivating item")
        Rails.logger.debug("* Controllers::DeactivatedController - reactivate - return instance variable #{'@'+@model.class.name.downcase}")
        self.instance_variable_set('@'+@model.class.name.downcase, item)
        render :action => 'edit', :id => item.id
      end
    else
      Rails.logger.error("E Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope")
    end
  end
  
end