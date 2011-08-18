class ApplicationController < ActionController::Base
  protect_from_forgery

  BASE_PARAMS_FILTER = {} # see safe_params_init - default safe params - a hash of arrays, such as a hash of tables, with an array of fields that are bulk updatable
    # BASE_PARAMS_FILTER = {'user' => ['created_at', 'updated_at']}
    # e.g. 'controller' => ['user'], 'action' => ['index', 'view'] would only allow index and view actions for only the user controller
  
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
  # ** provide good test coverage
  # ** provide better error handling, such as providing exception handling
  # ** provide for replacement of a matched hash value (for more default handling options, or possibly for model validations)
  # - possibly provide for allowing fields for all models
  # - possibly provide for removal of fields from a matched hash value (part of protected options, plus more default handling options)
  # - clean up code (but still with proper error handling)
  # - develop a better user interface that might:
  #   - method to add a safe field to a model
  # - expand to provide the protected option in addition to the accessible one currently available
  # - add the ability to process 'params' hash values that are not hashes, but single values (especially if proves useful).
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
    # my_params_filter is a custom merge of the safe_params passed and the BASE_PARAMS_FILTER default values
    my_params_filter = BASE_PARAMS_FILTER.merge(safe_params) { |key, base_p, safe_p|
      # make sure each safe params hash item is an array
      if !base_p.array? || !safe_p.array?
        logger.error("safe_params are not an array in hash - error")
        if base_p.array?
          base_p
        elsif safe_p.array?
          safe_p
        else
          []
        end
      else
        # return the union of the two arrays
        logger.debug("merged safe params")
        base_p | safe_p
      end
    }
    @safe_params_filter = my_params_filter
    # loop through all of the 'param' hash entries - only filter if matches a hash entry in safe params
    @original_params = params
    @original_params.each do |key, value|
      if my_params_filter.has_key?(key)
        # my_params_fields is the array of fields for the matched key/model
        my_params_fields = my_params_filter.fetch(key)
        logger.debug("match on #{key}'s safe fields: #{my_params_fields}")
        logger.debug("params to match (value) = #{value}")
        matched_params = my_value = value.nil? ? {} : value
        keyed_removed_params = {}
        logger.debug("params to match = #{my_value}")
        my_value.each do |field, val|
          if !my_params_fields.include?(field)
            # remove this - not in the safe params filter
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
