class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'capybara'
  
  include ApplicationHelper
  
  before_filter :load_user_session
  after_filter :save_user_session
  
  def initialize
    super
    @user_session = UserSession.new
  end
  
  def load_user_session
    #logger.debug ("session = "+session.inspect) if !session.nil?
    @user_session = UserSession.new (session)
    if @user_session.errors.count > 0
      notify_error("Error restoring session")
      @user_session.errors.each do |attr, msg|
        logger.debug("Session error: "+msg)
      end
      # redirect_to('/home/errors')
      @user_session.errors.clear
      # redirect_to('/signin')
    end
    #logger.debug ("* user session created:  "+@user_session.inspect)
    (@user_session.signed_in?) ? logger.debug('* load_user_session Signed in!') : logger.debug('* load_user_session Signed out!') 
  end

  def save_user_session
    (session[:current_user_id].nil?) ? logger.debug('* start of save_user_session - no session user id') : logger.debug('* start of save_user_session - have a session user id!') 
    @user_session.save_user_session 
    session[:current_user_id] = @user_session.current_user_id
    session[:time_last_accessed] = Time.now
    logger.debug ("time_last_accessed = #{session[:time_last_accessed].to_s}")
    #logger.debug ("* user session saved:  "+@user_session.inspect)
    (@user_session.signed_in?) ? logger.debug('* save_user_session Signed in!') : logger.debug('* save_user_session Signed out!') 
    (@user_session.current_user_id.nil?) ? logger.debug('* save_user_session - no user id') : logger.debug('* save_user_session - have a user id!') 
  end
  
    
  # to provide a replacement for attr-accessible, but at the controller level.
  # can't use param_protected gem because it is not working in rails 3 at development time.
  # filters and updates items in the 'params' hash.
  # returns errors array, to allow for custom error handling
  # usage in xxx_controller.rb:
  #   before_filter do |controller|
  #     # to filter on the 'xxx' model, only allowing mass updates to the safe fields: 'first_name', 'last_name', 'email' and 'username'.
  #     # removes any xxx model fields that are not in the safe fields list.
  #     # all other 'params' hash items are left alone.
  #
  #     @errors = safe_params_init({'user' => ['first_name', 'last_name', 'email', 'username']})
  #     if @errors.count > 0 then render home_errors_path end
  #   end
  #
  #
  # enhancement possibilities:
  # ** provide better test coverage
  # ** provide better error handling, such as providing exception handling, with the possiblity of raising errors here up to user
  # ** provide for a default hash value (validations for models, all controllers, by specific controller, etc)
  # - possibly provide for removal of fields from a matched hash value (part of protected options, plus more default handling options)
  # - possibly provide for blacklisted fields (instead of whitelisted fields).
  # - clean up code (but still with proper error handling)
  #       - generic hash method required_hash_keys to confirm that a hash has required key entries.
  #       - generic hash method black_listed_hash_keys to confirm that a hash has no entries in the black listed key entries.
  #       - generic hash method white_listed_hash_keys to confirm that a hash has all entries in the white listed key entries
  # - develop a better user interface that might provide a class that allows adding/removing fields to a model
  # - develop this as a gem
  #
  # Dave Taylor - Taylored Web Sites (tayloredwebsites.com) - 2011-Aug-16
  def safe_params_init (safe_params)

    @param_errors = Array.new()
    logger.debug("ApplicationController.safe_params_init was sent params: #{params}")

    #logger.debug("original params = #{params}")
    # make sure that safe_params is a hash
    if safe_params.nil? || !safe_params.class == hash
      logger.error("safe_params is nil or not a hash - error")
      # possible code to add errors to a active record model class created before this call
      # safe_model.errors.add(:base, "safe_params is nil or not a hash - error")
      @param_errors.push("safe_params is nil or not a hash - error")
      safe_params = {}
    end
    # loop through all of the 'param' hash entries - only filter if matches a hash entry in safe params
    @original_params = params
    logger.debug("ApplicationController.safe_params_init - safe_params: #{safe_params}")
    logger.debug("ApplicationController.safe_params_init - @original_params: #{@original_params}")
    @original_params.each do |key, value|
      if safe_params.has_key?(key)
        # matched on key, we should perform filtering on the values for that key
        # my_params_fields is the array of fields (from safe_params) for the matched key/model
        my_params_fields = safe_params.fetch(key)
        logger.debug("match on #{key}'s safe fields: #{my_params_fields}")
        matched_params = my_value = value.nil? ? {} : value
        logger.debug("params to match = #{my_value}")
        my_value.each do |field, val|
          if !my_params_fields.include?(field)
            logger.error("param has #{key} with '#{field}', which is not in the safe params list")
            @param_errors.push("param has #{key} with '#{field}', which is not in the safe params list")
            matched_params.delete(field)
          end
        end
        if @param_errors.length > 0
          logger.debug("replaced #{key} with only safe values #{matched_params}")
          params[key] = matched_params
        end
      else
        logger.debug("no match on #{key}")
      end
    end
    logger.debug("ApplicationController safe_params_init for params: #{params} got #{@param_errors}") if @param_errors.size > 0
    return @param_errors
  end
  
  
  # to provide a replacement for validates_presence_of, but at the controller level.
  # checks the items in the 'params' hash.
  # returns errors array, to allow for custom error handling
  # usage in xxx_controller.rb:
  #   before_create do 
  #     # to filter on the 'xxx' model, only allowing creates with the minimum the required fields: 'email' and 'username'.
  #     # removes any xxx model fields that are not in the safe fields list.
  #     # all other 'params' hash items are left alone.
  #
  #     @errors = required_params_init({'user' => ['email', 'username']})
  #     if @errors.count > 0 then render home_errors_path end
  #   end
  #
  #
  # enhancement possibilities:
  # ** provide better test coverage
  # ** provide better error handling, such as providing exception handling, with the possiblity of raising errors here up to user
  # ** provide for a default hash value (validations for models, all controllers, by specific controller, etc)
  # - possibly provide for removal of fields from a matched hash value (part of protected options, plus more default handling options)
  # - possibly provide for blacklisted fields (instead of whitelisted fields).
  # - clean up code (but still with proper error handling)
  #       - generic hash method required_hash_keys to confirm that a hash has required key entries.
  #       - generic hash method black_listed_hash_keys to confirm that a hash has no entries in the black listed key entries.
  #       - generic hash method white_listed_hash_keys to confirm that a hash has all entries in the white listed key entries
  # - develop a better user interface that might provide a class that allows adding/removing fields to a model
  # - develop this as a gem
  #
  # Dave Taylor - Taylored Web Sites (tayloredwebsites.com) - 2011-Aug-16
  def required_params_init (required_params)

    @param_errors = Array.new()
    logger.debug("ApplicationController.required_params_init was sent params: #{params}")

    # make sure that required_params is a hash
    if required_params.nil? || !required_params.class == hash
      logger.error("required_params is nil or not a hash - error")
      @param_errors.push("required_params is nil or not a hash - error")
      required_params = {}
    end
    # loop through all of the 'param' hash entries - only filter if matches a hash entry in safe params
    @original_params = params
    @original_params.each do |key, value|
      if required_params.has_key?(key)
        # matched on key, we should perform filtering on the values for that key
        # my_params_fields is the array of fields (from required_params) for the matched key/model
        my_params_fields = required_params.fetch(key)
        logger.debug("match on #{key}'s required fields: #{my_params_fields}")
        matched_params = my_value = value.nil? ? {} : value
        logger.debug("params to match = #{my_value}")
        my_params_fields.each do |field|
          if !my_value.include?(field)
            logger.error("param has #{key} without '#{field}', which is in the required params list.")
            @param_errors.push("param has #{key} without '#{field}', which is in the required params list.")
          end
        end
        if @param_errors.length > 0
          logger.debug("param #{key} was missing some of #{matched_params}")
        end
      end
    end
    logger.debug("ApplicationController required_params_init for params: #{params} got #{@param_errors}") if @param_errors.size > 0
    return @param_errors
  end
  
  def notify_error (message)
    logger.error(message)
    flash[:notice] = message
  end
  
  def notify_warning (message)
    logger.warn(message)
    flash[:notice] = message
  end
  
  def notify_success (message)
    logger.info(message)
    flash[:notice] = message
  end
  
end
