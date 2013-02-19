module Models::CommonMethods
  
  ######################################################
  # common methods to be available across all models
  ######################################################
  
  def method_missing(method, *args)
    # Rails.logger.debug("* Models::CommonMethods.method_missing method:#{method}, args:#{args.inspect.to_s}")
    # if method.to_s == 'validate_save'
    #   Rails.logger.debug("* Models::CommonMethods.method_missing - ignore validate_save (call to super for no deactivated.rb module included)")
    # else
      super
    # end
  end
  
  # html save display of field
  def show_field(field_name)
    if (defined? @model.deactivated_module)
      html_escape( ''+('*' if !self.deactivated?)+(self.send(field_name.to_sym).to_s) )
    else
      html_escape( ''+(self.send(field_name.to_sym).to_s) )
    end
  end

  # see if field is required
  # idea modified from http://www.keenertech.com/articles/2011/06/26/recipe-detecting-required-fields-in-rails
  def required?(field_name)
    model_class = self.class.name.constantize
    Rails.logger.debug("@@@@ Models::CommonMethods model_class = #{model_class} check on field #{field_name}")
    is_req = model_class.validators_on(field_name).map(&:class).include?(ActiveModel::Validations::PresenceValidator)
    Rails.logger.debug("@@@@ Models::CommonMethods field #{field_name} required? is #{is_req.to_s}")
    is_req
  end
end
