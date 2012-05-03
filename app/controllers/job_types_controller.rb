class JobTypesController< SecureApplicationController

 # allow records to be deactivated using extras/controllers/deactivated_controller.rb
 include Controllers::DeactivatedController

 def initialize
   # this is within the estimation maintenance sub-application
   @systemc = 'estimmaint'
   Rails.logger.debug("* JobTypesController.initialize - @systemc:#{@systemc}")
   super
 end

 before_filter do |controller|
   self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
 end

 def self.list
   self.new.get_scope().order('sort_order')
 end

 # chain current scope with any modules that have set scope (e.g. DeactivatedController)
 def get_scope(cur_scope = nil)
   # base default scope is set up here so that deactivated module can update this
   cur_scope = JobType.scoped if (cur_scope.nil?)
   return (defined?(super)) ? super(cur_scope) : cur_scope
 end

 # GET /job_types
 def index
   @job_types = get_scope().order('sort_order')
 end

 # GET /job_types/list
 def list
   index
 end

 # GET /job_types/:id
 def show
   @job_type = get_scope().find(params[:id])
 end

 # GET /job_types/new
 def new
   Rails.logger.debug("* JobTypesController.new - params = #{params.inspect.to_s}")
   # only pass attribute parameters to new method (to pre-initialize params such as parent association id)
   # todo - limit params to accessible attributes!
   attribute_params = params.dup
   attribute_params.delete_if{|key, val| JobType.new.attribute_names.index(key).nil? }
   @job_type = JobType.new(attribute_params)
 end

 # GET /job_types/:id/edit
 def edit
   @job_type = get_scope().find(params[:id])
 end

 # POST /job_types
 def create
   Rails.logger.debug("* JobTypesController.create - params = #{params.inspect.to_s}")
   @job_type = JobType.new(params[:job_type])
   if @job_type.save
     # redirect_to @job_type, notice: 'JobType was successfully created.'
     render :action => 'show'
   else
     render :action => "new"
   end
 end

 # PUT /job_types/:id
 def update
   # updates are passed to the deactivated controller, as it knows how to handle deactivated records
   super # call to parent (e.g. Controllers::DeactivatedController)
 end

 # DELETE /job_types/:id
 def destroy
   # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
   super # call to parent (e.g. Controllers::DeactivatedController)
 end
end
