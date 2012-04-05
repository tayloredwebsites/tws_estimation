class ComponentsController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the maintenance sub-application
    @systemc = 'estim'
    Rails.logger.debug("* ComponentController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    # Rails.logger.debug("* ComponentsController.before_filter called")
    # @component_types = ComponentTypesController.new.get_scope().all
    # Rails.logger.debug("* ComponentsController.before_filter - @component_types:#{@component_types.inspect.to_s}")
    # @defaults = DefaultsController.new.get_scope().all
    # Rails.logger.debug("* ComponentsController.before_filter - @defaults:#{@defaults.inspect.to_s}")
  end
  
  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = Component.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /components/menu
  def menu
  end

  # GET /components
  def index
    @components = get_scope().joins(:component_type).order('component_types.sort_order, components.description')
  end

  # GET /components/list
  def list
    @components = get_scope().joins(:component_type).order('components.description')
  end

  # GET /components/:id
  def show
    @component = get_scope().find(params[:id])
  end

  # GET /components/new
  def new
    Rails.logger.debug("* ComponentsController.new - params = #{params.inspect.to_s}")
    @component = Component.new
  end

  # GET /components/:id/edit
  def edit
    @component = get_scope().find(params[:id])
  end

  # POST /components
  def create
    Rails.logger.debug("* ComponentsController.create - params = #{params.inspect.to_s}")
    @component = Component.new(params[:component])
    if @component.save
      # redirect_to @component, notice: 'Component was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /components/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /components/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
