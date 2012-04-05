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

    
end
