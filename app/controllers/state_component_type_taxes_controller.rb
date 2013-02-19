class StateComponentTypeTaxesController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController

  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* StateComponentTypeTaxesController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = StateComponentTypeTax.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /state_component_type_taxes/menu
  def menu
  end

  # GET /state_component_type_taxes
  def index
    @state_component_type_taxes = get_scope().joins(:state).joins(:component_type).joins(:job_type).order( 'states.name, job_types.name, component_types.sort_order, component_types.description')
  end

  # GET /state_component_type_taxes/:id
  def show
    @state_component_type_tax = get_scope().find(params[:id])
  end

  # GET /state_component_type_taxes/new
  def new
    Rails.logger.debug("* StateComponentTypeTaxesController.new - params = #{params.inspect.to_s}")
    # only pass attribute parameters to new method (to pre-initialize params such as parent association id)
    # todo - limit params to accessible attributes!
    attribute_params = params.dup
    attribute_params.delete_if{|key, val| StateComponentTypeTax.new.attribute_names.index(key).nil? }
    @state_component_type_tax = StateComponentTypeTax.new(attribute_params)
  end

  # GET /state_component_type_taxes/:id/edit
  def edit
    @state_component_type_tax = get_scope().find(params[:id])
  end

  # POST /state_component_type_taxes
  def create
    Rails.logger.debug("* StateComponentTypeTaxesController.create - params = #{params.inspect.to_s}")
    @state_component_type_tax = StateComponentTypeTax.new(params[:state_component_type_tax])
    if @state_component_type_tax.save
      # redirect_to @state_component_type_tax, notice: 'StateComponentTypeTax was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /state_component_type_taxes/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /state_component_type_taxes/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
