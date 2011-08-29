class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  # to provide a replacement for attr-accessible, but at the controller level.
  # can't use param_protected gem because it is not working in rails 3 at development time.
  # filters and updates items in the 'params' hash.
  # usage in xxx_controller.rb:
  #   before_filter do |controller|
  #     # to filter on the 'user' model, only allowing mass updates to the safe fields: 'first_name', 'last_name', 'email' and 'username'.
  #     # removes any user model fields that are not in the safe fields list.
  #     # all other 'params' hash items are left alone.
  #     safe_params_init({'user' => ['first_name', 'last_name', 'email', 'username']})
  #   end
  #
  # enhancement possibilities:
  # ** provide better test coverage
  # ** provide better error handling, such as providing exception handling, with the possiblity of raising errors here up to user
  # ** provide for a default hash value (validations for models, all controllers, by specific controller, etc)
  # - possibly provide for removal of fields from a matched hash value (part of protected options, plus more default handling options)
  # - possibly provide for blacklisted fields (instead of whitelisted fields).
  # - clean up code (but still with proper error handling)
  # - develop a better user interface that might provide a class that allows adding/removing fields to a model
  # - develop this as a gem
  #
  # Dave Taylor - Taylored Web Sites (tayloredwebsites.com) - 2011-Aug-16
  def safe_params_init (safe_params)
    #logger.debug("original params = #{params}")
    # make sure that safe_params is a hash
    if safe_params.nil? || !safe_params.class == hash
      logger.error("safe_params is nil or not a hash - error")
      safe_params = {}
    end
    # loop through all of the 'param' hash entries - only filter if matches a hash entry in safe params
    @original_params = params
    @original_params.each do |key, value|
      if safe_params.has_key?(key)
        # my_params_fields is the array of fields for the matched key/model
        my_params_fields = safe_params.fetch(key)
        logger.debug("match on #{key}'s safe fields: #{my_params_fields}")
        matched_params = my_value = value.nil? ? {} : value
        keyed_removed_params = {}
        logger.debug("params to match = #{my_value}")
        my_value.each do |field, val|
          if !my_params_fields.include?(field)
            logger.error("param has #{key} with '#{field}', which is not in the safe params list")
            matched_params.delete(field)
            keyed_removed_params[field]=val
          end
        end
        if keyed_removed_params.length > 0
          logger.debug("updated #{key} with new values #{matched_params}")
          params[key] = matched_params
        end
      end
    end
    #logger.debug("params is now = #{params}")
  end
  
end
