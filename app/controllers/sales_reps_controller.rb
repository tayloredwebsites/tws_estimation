class SalesRepsController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController

  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* SalesRepsController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    # Rails.logger.debug("* SalesRepsController.before_filter called")
    # @sales_rep_types = SalesRepTypesController.new.get_scope().all
    # Rails.logger.debug("* SalesRepsController.before_filter - @sales_rep_types:#{@sales_rep_types.inspect.to_s}")
    # @defaults = DefaultsController.new.get_scope().all
    # Rails.logger.debug("* SalesRepsController.before_filter - @defaults:#{@defaults.inspect.to_s}")
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = SalesRep.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /sales_reps/menu
  def menu
  end

  # GET /sales_reps
  def index
    @sales_reps = get_scope().joins(:user).order('users.last_name, users.first_name')
  end

  # GET /sales_reps/list
  def list
    index
  end

  # GET /sales_reps/:id
  def show
    @sales_rep = get_scope().find(params[:id])
  end

  # GET /sales_reps/new
  def new
    Rails.logger.debug("* SalesRepsController.new - params = #{params.inspect.to_s}")
    # only pass attribute parameters to new method (to pre-initialize params such as parent association id)
    # todo - limit params to accessible attributes!
    attribute_params = params.dup
    attribute_params.delete_if{|key, val| SalesRep.new.attribute_names.index(key).nil? }
    @sales_rep = SalesRep.new(attribute_params)
  end

  # GET /sales_reps/:id/edit
  def edit
    @sales_rep = get_scope().find(params[:id])
  end

  # POST /sales_reps
  def create
    Rails.logger.debug("* SalesRepsController.create - params = #{params.inspect.to_s}")
    @sales_rep = SalesRep.new(params[:sales_rep])
    if @sales_rep.save
      # redirect_to @sales_rep, notice: 'SalesRep was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /sales_reps/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /sales_reps/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
