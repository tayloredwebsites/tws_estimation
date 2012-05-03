class StatesController < SecureApplicationController

 # allow records to be deactivated using extras/controllers/deactivated_controller.rb
 # include Controllers::DeactivatedController

 def initialize
   # this is within the estimation maintenance sub-application
   @systemc = 'estimmaint'
   Rails.logger.debug("* StatesController.initialize - @systemc:#{@systemc}")
   super
 end

 before_filter do |controller|
   self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
 end

 def self.list
   self.new.get_scope().order('name')
 end

 # chain current scope with any modules that have set scope (e.g. DeactivatedController)
 def get_scope(cur_scope = nil)
   # base default scope is set up here so that deactivated module can update this
   cur_scope = State.scoped if (cur_scope.nil?)
   return (defined?(super)) ? super(cur_scope) : cur_scope
 end

 # GET /states
 def index
   @states = get_scope().order('name')
 end

 # GET /states/list
 def list
   @states = get_scope().order('code')
 end

 # GET /states/:id
 def show
   @state = get_scope().find(params[:id])
 end

 # GET /states/new
 def new
   Rails.logger.debug("* StatesController.new - params = #{params.inspect.to_s}")
   # only pass attribute parameters to new method (to pre-initialize params such as parent association id)
   # todo - limit params to accessible attributes!
   attribute_params = params.dup
   attribute_params.delete_if{|key, val| State.new.attribute_names.index(key).nil? }
   @state = State.new(attribute_params)
 end

 # GET /states/:id/edit
 def edit
   @state = get_scope().find(params[:id])
 end

 # POST /states
 def create
   Rails.logger.debug("* StatesController.create - params = #{params.inspect.to_s}")
   @state = State.new(params[:state])
   if @state.save
     # redirect_to @state, notice: 'State was successfully created.'
     render :action => 'show'
   else
     render :action => "new"
   end
 end

 # DELETE (DESTROY) /(controller)/:id
 def destroy
   @state = get_scope().find(params[:id])
   if (!@state.nil?)
     Rails.logger.debug("* StatesController.destroy State with id :#{params[:id]}")
     authorize! :delete, @state   # authorize from CanCan::ControllerAdditions
     if @state.destroy
       notify_success( I18n.translate('errors.success_method_obj_id',
         :method => 'destroy',
         :obj => 'State',
         :id => params[:id] )
       )
       @states = self.list
       render :action => 'index'
     else
       Rails.logger.debug("* StatesController.destroy errors.count: #{@state.errors.count.to_s}")
       if item.errors[:base].count > 0
         Rails.logger.debug("* StatesController.destroy errors: #{@state.errors.inspect.to_s}")
         notify_error( item.errors[:base][0] )
       else
         Rails.logger.debug("* StatesController.destroy Error deleting user #{@state.id}")
         notify_error("Error deleting State #{@state.id}")
       end
       Rails.logger.debug("* StatesController.destroy - return instance variable #{@state.class.name.underscore}")
       render :action => 'edit', :id => item.id
     end
   else
     Rails.logger.error("E StatesController Error on attempt to Destroy State.id:#{params[:id]}")
     redirect_to(home_errors_path)
   end
 end

 # PUT /(controller)/:id
 def update
   @state = get_scope().find(params[:id])
   if (!@state.nil?)
     Rails.logger.debug("* StatesController.update State with id :#{params[:id]}")
     authorize! :update, @state   # authorize from CanCan::ControllerAdditions
     @state.update_attributes(params[:state].dup)
     # Rails.logger.debug("* StatesController.update - user after update attributes:#{@state.inspect.to_s}")
     if @state.errors.count == 0
       notify_success( I18n.translate('errors.success_method_obj_id',
         :method => 'update',
         :obj => State,
         :id => params[:id] )
       )
       render :action => 'show'
     else
       render :action => "edit"
     end
   else
     Rails.logger.error("E StatesController Attempt to Update State.id:#{params[:id]}")
     redirect_to(home_errors_path)
   end
 end

end
